Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class @NewslistBuilder
  constructor: ->
    $(window).on 'click', 'nav #slide-to-news', =>
      $.scrollTo $('#newslist header h2') ,{duration: 'fast'}

  fetch_and_load: (keys) ->
    $.getJSON '/api/n', {bookings: keys}, (data) =>
      $('#newslist').replaceWith ich.newslist(data)

  init: ->
    keys = $('full_schedule_horizontal').data('booking-keys')
    if keys
      keys = JSON.parse keys
    else
      uri = window.location.pathname
      p = uri.split('/')
      keys =  p[2...p.length]
    @fetch_and_load keys
    $('nav').append('<li><a id="slide-to-news" href="#news">News</a></li>')
