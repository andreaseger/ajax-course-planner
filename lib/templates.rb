module Sinatra
  module Templates
    def templates
      @templates ||= [
        { name: 'booking',
          template: '
<li class="booking length{{ timeslot.length }} shour{{ timeslot.start_hour }} smin{{ timeslot.start_minute }}" data-booking-key="{{& key }}">
  {{> course }}
  <ul class="people">
  {{# people }}
    {{> person }}
  {{/ people }}
  </ul>
  {{> room }}
</li>
'}
      ]
    end

    def partials
      @partials ||= [
        { name: 'person',
          template: '
<li class="person">
  <a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{& name }}" target="_blank">{{ label }}</a>
</li>
'},
        { name: 'course',
          template: '
<span class="course">
  <a href="http://fi.cs.hm.edu/fi/rest/public/modul/title/{{& course.name }}" target="_blank">{{ course.label }}</a>
</span>
'},
        { name: 'room',
          template: '<span class="room">{{ room.label }}</span>'}
      ]
    end
  end
end

=begin

=end
