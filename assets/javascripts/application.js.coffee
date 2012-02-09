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

  #TODO handle the switch to the big schedule and back
  Bookingslist.build_for_group State.group, false
  $('#groups').val State.group

@meta = 
  id: 'bookings_list'
  page: 'meta[name=pagename]'

init = ->
  $('footer').on 'click', '#clear_cookie', =>
    $.cookie("schedule-data",null)
  $ ->
    switch $(meta.page).attr 'content'
      when 'bookingslist' then Bookingslist.init()
      when 'schedule' then Schedule.init()

###
$.getJSON('/templates.json', function (data) {
  $.each(data, function (i,template) {
    ich.addTemplate(template.name, template.template);
  });
  template_finished();
});
function template_finished(){
  $('footer').on('click', '#clear_cookie', function(){
    $.cookie("schedule-data",null)
  });
  $(function(){
    switch($(meta.page).attr('content')){
    case 'bookingslist':
      init_bookingslist();
      break;
    case 'schedule':
      init_schedule();
      break;
    };
  });
}
###
