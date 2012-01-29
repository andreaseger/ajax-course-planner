module Sinatra
  module Templates
    def templates
      @templates ||= [
        { name: 'booking',
          template: '<div class="booking length-{{timeslot.length}} timeslot-{{timeslot.label}}">
{{>course}}{{>suffix}}
<ul class="people">
  {{>teacher-li}}
  {{#people}}
    {{>person}}
  {{/people}}
</ul>
<button type="button" class="bookings-schedule-toggle" data-booking-key="{{& key}}">&#x219C;<br />&#x219D;</button>
{{>room}}
<div class="clear"></div></div>'
        },
        { name: 'schedule',
          template: '<div id="schedule">
<h2 id="schedule-header">Schedule:</h2>
{{#bookings}}
  {{> pbooking }}
{{/bookings}}
</div>'
        },
        { name: 'structure',
          template: '<div id="{{id}}">
  {{#days}}
    {{>day}}
  {{/days}}
</div>'
        },
        { name: 'groupselect',
          template: '<div id="groups-div">
<h2 id="bookings-header">Bookings</h2>
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
          template:'<div class="booking">
{{>course}}{{>suffix}}
{{>timeslot}}{{>room}}
{{>teacher}}<button type="button" class="bookings-schedule-toggle" data-booking-key="{{& key}}">&#x2718;</button>
<div class="clear"></div>
</div>'
        },
        { name: 'teacher',
          template: '{{#label}}
<div class="teacher">
  <a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{&name}}" target="_blank">{{label}}</a>
</div>{{/label}}'
        },
        { name: 'teacher-li',
          template: '{{#teacher.label}}
<li class="teacher">
  <a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{&teacher.name}}" target="_blank">{{teacher.label}}</a>
</li>{{/teacher.label}}'
        },
        { name: 'person',
          template: '{{#label}}
<li class="person">
  <a href="http://fi.cs.hm.edu/fi/rest/public/person/name/{{&name}}" target="_blank">{{label}}</a>
</li>{{/label}}'
        },
        { name: 'course',
          template: '<div class="course">
  <a href="http://fi.cs.hm.edu/fi/rest/public/modul/title/{{&name}}" target="_blank">{{label}}</a>
</div>'
        },
        {
          name: 'timeslot',
          template: '<div class="timeslot">
  {{day.label}} | {{label}}
</div>'
        },
        { name: 'suffix',
          template: '<div class="suffix"><em>{{suffix}}</em></div>'},
        { name: 'room',
          template: '<div class="room">{{label}}</div>'},
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
