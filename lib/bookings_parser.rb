require_relative 'parser'
require_relative 'booking'
class BookingsParser < Parser
  def all_bookings=(v)
    @all_bookings = v
  end
  def all_bookings
    @all_bookings ||= []
  end
  def remove_old_bookings
    #todo
  end
  def update_data
    get_timetables.each do |booking|
      room = build_room(booking.xpath('room').text)
      next if room.nil?
      timeslot = build_timeslot(booking.xpath('weekday').text,
                                booking.xpath('starttime').text,
                                booking.xpath('stoptime').text)
      teacher = build_person(booking.xpath('teacher').text)
      suffix = booking.xpath('suffix').text
      booking.xpath('courses/course').each do |course|
        b = Booking.from_hash(
          {
            timeslot: timeslot,
            rooms: [room],
            group: build_group(course.xpath('group').text),
            course: build_course(course.xpath('modul').text),
            teacher: teacher,
            people: course.xpath('teacher').map {|t| t.text == teacher.try(:[],:name) ? nil : build_person(t.text) }.compact,
            suffix: suffix
          })
        all_bookings << b
      end
    end
    p "before merge: #{all_bookings.count}"
    merge_similar
    p "after merge: #{all_bookings.count}"
    save_all
  end
  def save_all
    all_bookings.each(&:save)
  end
  def merge_similar
    all_bookings.map! { |b|
      #next b if b[:rooms].nil?
      booking = b
      rooms = all_bookings.select{|e| b.similar?(e) }
                          .reduce([]){|a, e| a | e[:rooms] }
      unless rooms.empty?
        booking[:rooms] = rooms
      end
      booking
    }#.each { |b| b[:rooms].uniq! }
     .uniq!
  end
private
  def get_timetables
    get_with_xpath('http://fi.cs.hm.edu/fi/rest/public/timetable/group.xml', '/list/timetable/day/time/booking') || []
  end
end
