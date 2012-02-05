/* Author: sch1zo

*/

function get_groups(){
  $.getJSON('/api/g',function(data){
    var current = $('#' + meta.id).data('group');
    $('#groupselect').replaceWith( ich.groupselect(data) )
    $('#groups').val(current);
  });
}
function update_page_title(title){
  document.title = title;
}
function toggle_in_cookie(key){
  var data=JSON.parse($.cookie("schedule-data"));
  if(data === null){
    data = {bookings: [key]};
  }else if($.inArray(key,data.bookings) === -1){
    data.bookings.push(key);
  }else{
    data.bookings.splice($.inArray(key,data.bookings),1);
  }
  $.cookie("schedule-data", JSON.stringify(data));
}
function update_schedule(){
  var cookie = $.cookie("schedule-data");
  var store=JSON.parse(cookie);
  if(store === null || store.bookings.length === 0){
    $('#schedule').text('');
  }else{
    $.getJSON('/api/s', store, function(data){
      data.permalink = "/schedule/" + store.bookings.join("/");
      $('#schedule').replaceWith(ich.schedule(data));
    });
  }
}
function update_bookings(group, push){
  var api_url = '/api/b/g/' + group;
  if(api_url){
    $.getJSON(api_url, function(data){
      $('#' + meta.id ).replaceWith( ich.bookings_list(meta) );

      $.each(data, function(index, elem) {
        html = ich.full_booking(elem)
        var div = $('#bookings-' + elem.timeslot.day.name + ' .' + elem.timeslot.label.replace(':',''));
        if(div.is(':empty')){
          div.append('<h4>' + elem.timeslot.label + '</h4>');
        }
        div.append(html);
      });

      var title = 'Bookings for ' + group;
      update_page_title(title);
      $('#bookings-header').text(title + ':')

      if(push){
        History.pushState({group: group, api_url: api_url}, title, '/bookings/g/' + group );
      }
    });
  }
}
function show_schedule_from_uri(){
  var bookings = window.location.pathname.split('/');
  $.getJSON('/api/s', {bookings: bookings}, function(data) {
    $('#schedule').replaceWith(ich.big_schedule(data))
  });
}
function cleanup_structure () {
  $('#' + meta.id).remove();
  $('#groupselect').remove();
}

var meta = {'days' : [{ 'name': 'mo', 'label': 'Montag'},
                      { 'name': 'di', 'label': 'Dienstag'},
                      { 'name': 'mi', 'label': 'Mittwoch'},
                      { 'name': 'do', 'label': 'Donnerstag'},
                      { 'name': 'fr', 'label': 'Freitag' }],
            'id' : 'bookings_list',
            'page' : 'meta[name=pagename]'
           };

function init_bookingslist(){
  get_groups();
  update_schedule();
  update_bookings($('#' + meta.id).data('group'), true);

  $('#groups').live('change',function(){
    update_bookings($(this).val(), true);
  });
  $('.day-header').live('click',function(){
    var div = $('#' + $(this).data('bookings-list'));
    if(div.is(':hidden')){
      $('.bookings').hide();
      div.toggle();
      $.scrollTo($(this),{duration: 'fast'})
    }else{
      div.toggle();
      $.scrollTo(0,{duration: 'fast'})
    }
  });

  $('.bookings-schedule-toggle').live('click',function(){
    var button = $(this)
    var key = button.data('booking-key');
    toggle_in_cookie(key);
    update_schedule();
  });
};

function init_schedule(){
  show_schedule_from_uri();
  cleanup_structure();
};

$(function(){
  $.getJSON('/templates.json', function (data) {
    $.each(data, function (i,template) {
      ich.addTemplate(template.name, template.template);
    });
  });

  var History = window.History;
  History.Adapter.bind(window,'statechange',function(){
    var State = History.getState().data;
    update_bookings(State.group, false);
    $('#groups').val(State.group);
  });
  switch($(meta.page).attr('content')){
  case 'bookingslist':
    init_bookingslist();
    break;
  case 'schedule':
    init_schedule();
    break;
  };
});
