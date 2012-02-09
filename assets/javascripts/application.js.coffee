#= require vendor
#= require bookingslist_builder
#= require groups_builder
#= require schedule_builder
#= require_self

$.getJSON '/templates.json', (data) =>
  ich.addTemplate(template.name, template.template) for template in data
  init()

History = window.History
History.Adapter.bind window, 'popstate', =>
  State = History.getState()

  switch State.data.pagename
    when 'bookingslist'
      @bookingslist_builder.from_history State.data
    when 'schedule'
      @schedule_builder.from_history State.data
  History.log(State.data, State.title, State.url)

@groups_builder = new GroupsBuilder()
@bookingslist_builder = new BookingslistBuilder()
@schedule_builder = new ScheduleBuilder()

@reset = ->
  $('#main').replaceWith ich.main

init = ->
  $('footer').on 'click', '#clear_cookie', =>
    $.cookie("schedule-data",null)
  $ ->
    switch $('meta[name=pagename]').attr 'content'
      when 'bookingslist'
        uri = window.location.pathname.split('/')
        bookingslist_builder.init(uri[uri.length - 1])
      when 'schedule'
        schedule_builder.init()
