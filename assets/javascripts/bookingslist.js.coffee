class @Bookingslist
  @init: ->
    Group.build_groupselect()
    Schedule.build_from_cookie()
    @build_for_group $('#bookings_list').data('group'), true
    @setup_handler()

  @setup_handler: ->
    $('#container').on 'change', '#groups', (e) =>
      @build_for_group $(e.currentTarget).val(), true

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
      Schedule.toggle_booking_in_cookie(key)
      Schedule.build_from_cookie()

  @build_for_group: (group, history = false) ->
    $.getJSON '/api/b/g', {group: group, structure: 'table_by_days'}, (data) =>
      $('#bookings_list').replaceWith ich.bookings_list(data)
      title = "Bookings for #{group}"
      document.title = title
      $('#bookings-header').text "#{title}:"
      if history
        History.pushState {pagename: 'bookingslist', group: group}, title, "/bookings/g/#{group}"

###
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
###
