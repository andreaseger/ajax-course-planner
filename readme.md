HM Course Planner with News
===

What is this
---

This is an attempt to build a responsive single site page to create a schedule for your courses at the [University of Applied Science Munich](http://www.hm.edu). Also it will show you the news from the bulletin board.

How it works
---

- Sinatra application to serve the bookings data
- it has Redis as database backend
- bookings will be updated via a rake task
- the data comes from [fi.cs.hm.edu](http://fi.cs.hm.edu/fi/rest/public/exam)
- all templates are using mustache
- ICanHaz/Mustache.js on the client to render the different sites dynamically
- client fetches the templates as json from the server
- jQuery and some plugins to do the javascript stuff

What it does
---

- browse through the bookings of each group and choose the ones you plan to attend
- chosen bookings will be saved in a cookie and shown next to the list of bookings
- for the chosen bookings, a permalink to your schedule is provided which lets you bookmark/share your schedule
- show you the news from the bulletin board for the profs you selected a
  course

How to run it
---

Install Redis; the app will connect to Redis on localhost on the default port. You can specify an other setup if you set REDIS_URL in your environment, i.e.:

    $ REDIS_URL='redis://:secret@1.2.3.4:9000/3'

This would connect to host 1.2.3.4 on port 9000, uses database number 3 using the password 'secret'.


    bundle install
    bundle exec rake update:bookings
    bundle exec puma -p4567

>> goto 127.0.0.1:4567/

Known Issues
---

- the bakground timeslot text in the big schedule view is messed up with
  Firefox, till now I didn't cared to fix that. It works in Chrome, Safari, Opera and IE9.
- IE on WP7.5 looks ok-ish it only does not like the font used, didn't test other mobile browser cause I lack the devices.
- Sometimes the bookings do not get merged correctly and appear multiple
  times, didn't investigate why that happends. Most of the times it works.
- no caching-header set
- pony mode needs improvments: more pony pics and better colors 

Who am I
---

Student at the University of Applied Science Munich who thought the given Representation of the courses and bookings sucks.
[@sch1zo](https://www.twitter.com/sch1zo)
[blog](http://sch1zo.github.com)
