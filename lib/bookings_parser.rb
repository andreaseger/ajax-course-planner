require_relative 'parser'
require_relative 'booking'
class BookingsParser < Parser
  def update_data
    get_timetables.each do |booking|
      room = build_room(booking.xpath('room').text)
      next if room.nil?
      booking.xpath('courses/course').each do |course|
        timeslot = build_timeslot(course.xpath('weekday').text,
                                booking.xpath('starttime').text,
                                booking.xpath('endtime').text)
        Booking.from_hash(
          {
            timeslot: timeslot,
            room: room,
            group: build_group(course.xpath('group').text),
            course: build_course(course.xpath('modul').text),
            teachers: course.xpath('teacher').map {|t| build_teacher(t.text) }
          }).save
      end
    end
  end
private
  def get_timetables
    get_with_xpath('http://fi.cs.hm.edu/fi/rest/public/timetable/group.xml', '/list/timetable/day/time/booking')
  end
end