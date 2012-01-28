module Sinatra
  module Templates
    def templates
      @templates ||= [
        { name: 'booking',
          template: '<div class="booking length-{{timeslot.length}} timeslot-{{timeslot.label}}">
  {{>course}}{{>suffix}}
  {{>room}}
  <ul class="people">
    {{>teacher-li}}
    {{#people}}
      {{>person}}
    {{/people}}
  </ul>
  <button type="button" class="bookings-schedule-toggle" data-booking-key="{{& key}}">Toggle</button>
</div>'
        },
        { name: 'schedule',
          template: '<div id="schedule">
<h2 id="schedule-header">Schedule:</h2>
<ul>
  {{#bookings}}
    {{> pbooking }}
  {{/bookings}}
</ul>
</div>'
        },
        { name: 'structure',
          template: '<div id="{{id}}">
  <h2 id="bookings-header">Bookings</h2>
  {{#days}}
    {{>day}}
  {{/days}}
</div>'
        },
        { name: 'groupsselect',
          template: '<div id="groups-div">
<span id="groups-select-label">Group: </span>
<select id="groups">
  {{#groups}}
    {{>groupoption}}
  {{/groups}}
</select></div>'
        }
      ]
    end

    def partials
      @partials ||= [
        { name: 'pbooking',
          template:'<li>
<strong>{{>course}}</strong>
{{>suffix}}
{{>room}}
<div>{{>timeslot}}{{>teacher}}</div>
<button type="button" class="bookings-schedule-toggle" data-booking-key="{{& key}}">Remove</button>
</li>'
        },
        { name: 'teacher',
          template: '{{#label}}
<span class="teacher">
  <a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{&name}}" target="_blank">{{label}}</a>
</span>{{/label}}'
        },
        { name: 'teacher-li',
          template: '{{#teacher.label}}
<li class="teacher">
  <strong><a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{&teacher.name}}" target="_blank">{{teacher.label}}</a></strong>
</li>{{/teacher.label}}'
        },
        { name: 'person',
          template: '{{#label}}
<li class="person">
  <a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{&name}}" target="_blank">{{label}}</a>
</li>{{/label}}'
        },
        { name: 'course',
          template: '<span class="course">
  <a href="http://fi.cs.hm.edu/fi/rest/public/modul/title/{{&name}}" target="_blank">{{label}}</a>
</span>'
        },
        {
          name: 'timeslot',
          template: '<span class="timeslot">
  {{day.label}} | {{label}}
</span>'
        },
        { name: 'suffix',
          template: '<em class="suffix">{{suffix}}</em>'},
        { name: 'room',
          template: '<span class="room">{{label}}</span>'},
        { name: 'day',
          template: %|<div id="{{name}}">
  <h3 class="day-header" data-bookings-list="bookings-{{name}}">{{label}}</h3>
  <div id="bookings-{{name}}" class="bookings">
    #{timeslots}
  </div>
</div>|
        },
        { name: 'groupoption',
          template: '<option value={{.}}>{{.}}</option>'}
      ]
    end
    def timeslots
      %w(08:15 10:00 11:45 13:30 15:15 17:00 18:45).map {|label|
        %{<div id="bookings-{{name}}-#{label.gsub(':','')}"></div>}
      }.join
    end
  end
end

=begin

=end
