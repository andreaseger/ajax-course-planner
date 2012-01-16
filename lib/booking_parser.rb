require_relative 'parser'
class BookingsParser < Parser
  def update_bookings
    get_timetables.each do |booking|
      room = build_room(booking.xpath('room').text)
      booking.xpath('courses/course').each do |course|
        timeslot = build_timeslot(course.xpath('weekday').text,
                                booking.xpath('starttime').text,
                                booking.xpath('endtime').text)
        Booking.form_hash(
          {
            timeslot: timeslot,
            room: room,
            group: build_group(course.xpath('group').text),
            course: build_course(course.xpath('modul')),
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
