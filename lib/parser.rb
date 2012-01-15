class Parser
  attr_accessor :database

  def initialize database
    database = database
  end

  def self.run database
    parser = Parser.new database
    parser.update_bookings
  end

  def update_bookings
    fetch_timetables.each do |booking|
      room = build_room(booking.xpath('room').text)
      booking.xpath('courses/course').each do |course|
        course = build_course(course.xpath('module'))
        timeslot = build_timeslot(course.xpath('weekday').text,
                                booking.xpath('starttime').text,
                                booking.xpath('endtime').text)
        group = build_group(course.xpath('group').text)
        teachers = build_teachers(course.xpath('teacher').map(&:text))
        save_booking(timeslot, room, group, course, teachers)
      end
    end
  end

private

  def save_booking timeslot, room, group, course, teachers
    data = {timeslot: timeslot,
            room: room,
            group: group,
            course: course,
            teachers: teachers}
    key = data.hash #TODO try something better here

    database.multi do
      database.set key, data.to_json

      teachers.each do |teacher|
        database.sadd "by_teacher:#{teacher[:name]}", key
        database.sadd "teachers", teacher[:name]
      end
      database.sadd "by_room:#{room[:name]}", key
      database.sadd "by_group:#{group[:name]}", key
      database.sadd "by_course:#{course[:name]}", key

      database.sadd "rooms", room[:name]
      database.sadd "groups", group[:name]
      database.sadd "courses", course[:name]
    end
  end

  def build_room room
    {
      name: room,
      label: room.upcase.insert(2,'.'),
      building: room[0],
      floor: room[1]
    }
  end

  def build_course course
    {
      name: course,
      label: get_modul_label(course)
    }
  end

  def build_group group
    {
      name: group
    }
  end

  def build_teachers teachers
    teachers.map do |teacher|
      {
        name: teacher,
        label: get_teacher_name(teacher)
      }
    end
  end

  def build_timeslot day, stime, etime
    {
      start_minute: stime.split(':')[1].to_i,
      start_hour: stime.split(':')[0].to_i,
      end_minute: etime.split(':')[1].to_i,
      end_hour: etime.split(':')[0].to_i
    }
  end

  def get url
    Timeout::timeout(5) do
      net = Net::HTTP.get_response(URI.parse(url))
      raise "HTTP Error: #{net.code}" if %w(404 500).include? net.code
      xml = Nokogiri::XML(net.body)
    end
  end
  def fetch_timetables
    xml = get 'http://fi.cs.hm.edu/fi/rest/public/timetable/group.xml'
    return xml.xpath('/list/timetable/day/time/booking')
  rescue => e
    p "[ERROR] fetch_timetables: #{e.message}"
    p e.backtrace
    exit 1
  end

  def get_modul_label modul
    xml = get "http://fi.cs.hm.edu/fi/rest/public/modul/title/#{modul}.xml"
    xml.xpath('/modul/name').first.text
  rescue => e
    p "[ERROR] get_modul_label: #{e.message}"
    p e.backtrace
    exit 1
  end

  def get_teacher_name teacher
    xml = get "http://fi.cs.hm.edu/fi/rest/public/person/name/#{teacher}.xml"
    person = xml.xpath('/person').first

    "#{person.xpath('title').text} #{person.xpath('firstname').text} #{person.xpath('lastname').text}"
  rescue => e
    p "[ERROR] get_teacher_name: #{e.message}"
    p e.backtrace
    exit 1
  end
end
