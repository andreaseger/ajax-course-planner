require_relative 'parser'
require_relative 'booking'
class BookingsParser < Parser
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
        Booking.from_hash(
          {
            timeslot: timeslot,
            room: room,
            group: build_group(course.xpath('group').text),
            course: build_course(course.xpath('modul').text),
            teacher: teacher,
            people: course.xpath('teacher').map {|t| t.text == teacher.try(:[],:name) ? nil : build_person(t.text) }.compact,
            suffix: suffix
          }).save
      end
    end
  end
private
  def get_timetables
    get_with_xpath('http://fi.cs.hm.edu/fi/rest/public/timetable/group.xml', '/list/timetable/day/time/booking') || []
  end
end
