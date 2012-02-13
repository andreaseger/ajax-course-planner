#= require vendor
#= require bookingslist_builder
#= require groups_builder
#= require schedule_builder
#= require_self

$.getJSON '/templates.json', (data) =>
  @templates = data
  ich.addTemplate(template.name, template.template) for template in data
  $(window).trigger('templates-loaded')

History = window.History
@groups_builder = new GroupsBuilder()
@bookingslist_builder = new BookingslistBuilder()
@schedule_builder = new ScheduleBuilder()

$(window).on 'templates-loaded', =>
  $ ->
    switch $('meta[name=pagename]').attr 'content'
      when 'bookingslist'
        uri = window.location.pathname.split('/')
        bookingslist_builder.init(uri[uri.length - 1])
      when 'schedule'
        schedule_builder.init()
  $(window).on 'statechange', =>
    State = History.getState()
    History.log(State.data, State.title, State.url)

    switch State.data.pagename
      when 'bookingslist'
        @bookingslist_builder.from_history State.data
      when 'schedule'
        @schedule_builder.from_history State.data

$('footer').on 'click', '#clear_cookie', =>
  $.cookie("schedule-data",null)
  $(window).trigger('statechange')

@reset = ->
  $('#main').replaceWith ich.main

