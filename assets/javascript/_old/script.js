/* Author: sch1zo

*/

var meta = {'days' : [{ 'name': 'mo', 'label': 'Montag'},
                      { 'name': 'di', 'label': 'Dienstag'},
                      { 'name': 'mi', 'label': 'Mittwoch'},
                      { 'name': 'do', 'label': 'Donnerstag'},
                      { 'name': 'fr', 'label': 'Freitag' }],
            'id' : 'bookings_list',
            'page' : 'meta[name=pagename]'
           };

$.getJSON('/templates.json', function (data) {
  $.each(data, function (i,template) {
    ich.addTemplate(template.name, template.template);
  });
  template_finished();
});

var History = window.History;
History.Adapter.bind(window,'statechange',function(){
  var State = History.getState().data;

  //TODO handle the switch to the big schedule and back
  update_bookings(State.group, false);
  $('#groups').val(State.group);
});

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
    store.structure = 'table_by_days'
    $.getJSON('/api/s', store, function(data){
      //data.permalink = "/schedule/" + store.bookings.join("/");
      $('#schedule').replaceWith(ich.schedule(data));
    });
  }
}
function update_bookings(group, push){
  $.getJSON('/api/b/g', {group: group, structure: 'table_by_days'}, function(data){
    $('#bookings_list').replaceWith( ich.bookings_list(data) );

    var title = 'Bookings for ' + group;
    update_page_title(title);
    $('#bookings-header').text(title + ':')

    if(push){
      History.pushState({pagename: 'bookingslist', group: group}, title, '/bookings/g/' + group );
    }
  });
}
function big_schedule_from_bookings(bookings){
  $.getJSON('/api/s', {bookings: bookings, exams: true, structure: 'table_by_times'}, function(data) {
    $('#schedule').replaceWith(ich.big_schedule_by_times(data.bookings))
    //TODO History
  });
}
function cleanup_structure () {
  $('#' + meta.id).hide();
  $('#groupselect').hide();
}

function init_bookingslist(){
  get_groups();
  update_schedule();
  update_bookings($('#bookings_list').data('group'), true);

  $('#container').on('change', '#groups', function(){
    update_bookings($(this).val(), true);
  });
  $('#container').on('click', '.day-header', function(){
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
  $('#container').on('click', '.bookings-schedule-toggle', function(){
    var key = $(this).data('booking-key');
    toggle_in_cookie(key);
    update_schedule();
  });
};

function init_schedule(){
  big_schedule_from_bookings(window.location.pathname.split('/'));
  cleanup_structure();
};

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
