#= require vendor
#= require bookingslist_builder
#= require groups_builder
#= require schedule_builder
#= require newslist_builder
#= require_self

$.getJSON '/templates.json', (data) =>
  @templates = data
  ich.addTemplate(template.name, template.template) for template in data
  $(window).trigger('templates-loaded')

History = window.History
@groups_builder = new GroupsBuilder()
@bookingslist_builder = new BookingslistBuilder()
@schedule_builder = new ScheduleBuilder()
@newslist_builder = new NewslistBuilder()

$(window).on 'templates-loaded', =>
  $ ->
    switch $('meta[name=pagename]').attr 'content'
      when 'bookingslist'
        uri = window.location.pathname.split('/')
        bookingslist_builder.init(uri[uri.length - 1])
      when 'schedule'
        schedule_builder.init()
        newslist_builder.init()
    $('section#disclaimer p').hide()
    toggle_pony($.cookie("pony"))

  $(window).on 'statechange', =>
    State = History.getState()
    History.log(State.data, State.title, State.url)

    switch State.data.pagename
      when 'bookingslist'
        @bookingslist_builder.from_history State.data
      when 'schedule'
        @schedule_builder.from_history State.data
        @newslist_builder.init()


@toggle_pony = (turn_on)->
  if turn_on
    $('body')[0].className = 'pony'
    $('footer #pony a').replaceWith("<a href='#'>Less Ponies.</a>")
    $('#pony-pics').show()
    $.cookie("pony", 1, {expire: 120})
  else
    $('body')[0].className = ''
    $('footer #pony a').replaceWith("<a href='#'>More Ponies!!!</a>")
    $('#pony-pics').hide()
    $.cookie("pony", null)

$('footer').on 'click', '#clear_cookie', =>
  $.cookie("schedule-data",null)
  $.cookie("pony",null)
  toggle_pony(false)
  $(window).trigger('statechange')
  return false

$('footer').on 'click', 'strong', =>
  $('section#disclaimer p').toggle()
$('footer').on 'click', '#pony a', =>
  if $('body')[0].className == "pony"
    if (_gaq) then _gaq.push(['_trackEvent', 'pony', 'deactivate'])
    toggle_pony(false)
  else
    if (_gaq) then _gaq.push(['_trackEvent', 'pony', 'activate'])
    toggle_pony(true)
  return false

@reset = ->
  $('#main').replaceWith ich.main
