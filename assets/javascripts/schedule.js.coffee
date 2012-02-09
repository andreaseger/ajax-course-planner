Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class @Schedule
  @toggle_booking_in_cookie: (key) ->
    data = JSON.parse $.cookie("schedule-data")
    unless data?
      data = {bookings: [key]}
    else if key in data.bookings
      data.bookings.remove key
    else
      data.bookings.push key
    $.cookie("schedule-data", JSON.stringify(data))

  @build_from_cookie: ->
    cookie = $.cookie("schedule-data")
    store = JSON.parse(cookie)
    if store? and store.bookings.length != 0
      store.structure = 'table_by_days'
      $.getJSON '/api/s', store, (data) =>
        $('#schedule').replaceWith ich.schedule(data)
    else
      $('#schedule').text ''

  @build_from_bookings: (bookings) ->
    $.getJSON '/api/s', {bookings: bookings, exams: true, structure: 'table_by_times'}, (data) =>
      $('#schedule').replaceWith ich.big_schedule_by_times(data.bookings)
      #TODO History

  @init: ->
    @build_from_bookings window.location.pathname.split('/')
    $("##{meta.id}").hide()
    $('#groupselect').hide()

###
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
function big_schedule_from_bookings(bookings){
  $.getJSON('/api/s', {bookings: bookings, exams: true, structure: 'table_by_times'}, function(data) {
    $('#schedule').replaceWith(ich.big_schedule_by_times(data.bookings))
    //TODO History
  });
}
function init_schedule(){
  big_schedule_from_bookings(window.location.pathname.split('/'));
  cleanup_structure();
};
###
