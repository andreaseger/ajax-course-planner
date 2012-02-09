class @BookingslistBuilder
  init: ->
    @groups_builder.groupselect()
    @schedule_builder.from_cookie()
    for_group $('#bookings_list').data('group')
    @setup_handler()

  setup_handler: ->
    $('#container').on 'change', '#groups', (e) =>
      for_group $(e.currentTarget).val()

    $('#container').on 'click', '.day-header', (e) =>
      div = $("##{$(e.currentTarget).data('bookings-list')}")
      if div.is(':hidden')
        $('.bookings').hide()
        div.toggle()
        $.scrollTo $(e.currentTarget), {duration: 'fast'}
      else
        div.toggle()
        $.scrollTo 0,{duration: 'fast'}

    $('#container').on 'click', '.bookings-schedule-toggle', (e) =>
      key = $(e.currentTarget).data('booking-key')
      @schedule_builder.toggle_booking_in_cookie(key)
      @schedule_builder.from_cookie()

  for_group: (group, history = true) ->
    $.getJSON '/api/b/g', {group: group, structure: 'table_by_days'}, (data) =>
      $('#bookings_list').replaceWith ich.bookings_list(data)
      title = "Bookings for #{group}"
      document.title = title
      $('#bookings-header').text "#{title}:"
      if history
        History.pushState {pagename: 'bookingslist', group: group}, title, "/bookings/g/#{group}"

  from_history: (history) ->
    @reset()
    @groups_builder.groupselect()
    @schedule_builder.from_cookie()
    for_group history.group, false
  hide: ->
    $("#bookings_list").hide()
    $('#groupselect').hide()
