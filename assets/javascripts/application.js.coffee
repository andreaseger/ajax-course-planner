#= require vendor
#= require bookingslist
#= require groupselect
#= require schedule
#= require_self

$.getJSON '/templates.json', (data) =>
  ich.addTemplate(template.name, template.template) for template in data
  init()

History = window.History
History.Adapter.bind window, 'statechange', =>
  State = History.getState().data

  switch State.pagename
    when 'bookingslist'
      @bookingslist_builder.from_history State
    when 'schedule'
      @schedule_builder.from_history State

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
      when 'bookingslist' then @bookingslist_builder.init()
      when 'schedule' then @schedule_builde.init()
