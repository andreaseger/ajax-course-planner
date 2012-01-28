module Sinatra
  module Templates
    def templates
      @templates ||= [
        { name: 'booking',
          template: '<div class="booking length-{{ timeslot.length }} shour-{{ timeslot.start_hour }} smin-{{ timeslot.start_minute }}" data-booking-key="{{& key }}">
  {{> course }}<em class="suffix">{{ suffix }}</em>
  <ul class="people">
  {{> teacher }}
  {{# people }}
    {{> person }}
  {{/ people }}
  </ul>
  {{> room }}
  {{> timeslot }}
</div>
'},
        { name: 'structure',
          template: '<div id="{{ id }}">
  {{# days }}
    {{> day }}
  {{/ days }}
</div>
'},
        { name: 'groupsselect',
          template: '<select id="groups">
  {{# groups }}
    {{> groupoption }}
  {{/ groups }}
</select>
'}

      ]
    end

    def partials
      @partials ||= [
        { name: 'teacher',
          template: '{{# label }}
  <li class="teacher">
    <strong><a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{& name }}" target="_blank">{{ label }}</a></strong>
  </li>{{/ label }}
'},
        { name: 'person',
          template: '<li class="person">
  <a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{& name }}" target="_blank">{{ label }}</a>
</li>
'},
        { name: 'course',
          template: '<span class="course">
  <a href="http://fi.cs.hm.edu/fi/rest/public/modul/title/{{& course.name }}" target="_blank">{{ course.label }}</a>
</span>
'},
        {
          name: 'timeslot',
          template: '<span class="timeslot">
  {{ timeslot.day.label }} {{ timeslot.label }} | {{ timeslot.length }} minutes
</span>
'},
        { name: 'room',
          template: '<span class="room">{{ room.label }}</span>'},
        { name: 'day',
          template: '<div id="{{name}}">
  <h3 class="day-header" data-bookings-list="bookings-{{name}}">{{ label }}</h3>
  <div id="bookings-{{name}}" class="bookings"></div>
</div>'},
        { name: 'groupoption',
          template: '<option value={{.}}>{{.}}</option>'}
      ]
    end
  end
end

=begin

=end
