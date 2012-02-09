Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class @Schedule
  #constructor:

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
      this.from_bookings store.bookings, false, 'table_by_days'
    else
      $('#schedule').text ''

  from_bookings: (keys, history = true, structure = 'table_by_times', exams = false ) ->
    $.getJSON '/api/s', {bookings: keys, structure: structure, exams: exams}, (data) =>
      html = switch structure
        when 'table_by_times' then ich.big_schedule_by_times(data.bookings)
        when 'table_by_days' then ich.schedule(data)
      $('#schedule').replaceWith html
      if history
        History.pushState {pagename: 'schedule', bookings: keys}, "/schedule/#{keys.join('/')}"

  from_history: ->
    @reset()
    from_bookings keys, false
    @bookingslist_builder.hide()

  init: ->
    this.from_bookings window.location.pathname.split('/')
