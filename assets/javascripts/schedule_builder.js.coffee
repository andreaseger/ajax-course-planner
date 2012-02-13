Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class @ScheduleBuilder
  constructor: ->
    $('#container').on 'click', '#schedule-permalink', (e) =>
      keys = $(e.currentTarget).data('booking-keys')
      reset()
      @from_bookings keys
      bookingslist_builder.hide()
      e.preventDefault()

  toggle_booking_in_cookie: (key) ->
    data = JSON.parse $.cookie("schedule-data")
    unless data?
      data = {bookings: [key]}
    else if key in data.bookings
      data.bookings.remove key
    else
      data.bookings.push key
    $.cookie("schedule-data", JSON.stringify(data))

  from_cookie: ->
    cookie = $.cookie("schedule-data")
    store = JSON.parse(cookie)
    if store? and store.bookings.length > 0
      @from_bookings store.bookings, false, 'table_by_days'
    else
      $('#schedule').text ''

  from_bookings: (keys, history = true, structure = 'table_by_times', exams = false ) ->
    $.getJSON '/api/s', {bookings: keys, structure: structure, exams: exams}, (data) =>
      html = switch structure
        when 'table_by_times' then ich.big_schedule_by_times(data.bookings)
        when 'table_by_days'
          data.keys = JSON.stringify(data.keys)
          ich.schedule(data)
      $('#schedule').replaceWith html
      $('meta[name=pagename]').attr 'content', 'schedule'
    if history
      History.pushState {pagename: 'schedule', bookings: keys, template: templates}, "Schedule", "/schedule/#{keys.join('/')}"

  from_history: (history) ->
    if history?
      reset()
      @from_bookings history.bookings, false
      bookingslist_builder.hide()

  init: ->
    uri = window.location.pathname
    p = uri.split('/')
    @from_bookings p[2...p.length]
    bookingslist_builder.hide()
    #History.pushState {pagename: 'schedule', bookings: p[2...p.length]}, window.location.pathname
