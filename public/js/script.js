/* Author: sch1zo

*/

var meta = {'days' : [{ 'name': 'mo', 'label': 'Montag'},
                      { 'name': 'di', 'label': 'Dienstag'},
                      { 'name': 'mi', 'label': 'Mittwoch'},
                      { 'name': 'do', 'label': 'Donnerstag'},
                      { 'name': 'fr', 'label': 'Freitag' }],
            'id' : 'bookings'
           };

$(function(){
  $.getJSON('/templates.json', function (data) {
    $.each(data.templates, function (i,template) {
      ich.addTemplate(template.name, template.template);
    });
    $.each(data.partials, function (i,template) {
      ich.addTemplate(template.name, template.template);
    });
  });
  $(window).bind("popstate", function() {
    var group = history.state.group;
    update_bookings(group, false);
    $('#groups').val(group);
  });
  get_groups();
  update_bookings($('#' + meta.id ).data('group'), false);
});

function get_groups(){
  $.getJSON('/api/g',function(data){
    var current = $('#groups').data('current');
    $('#groups').replaceWith( ich.groupsselect(data) );
    $('#groups').val(current);
    $('#groups').change(function(){
      update_bookings($(this).val(), true);
    });
  });
}
function update_page_title(title){
  document.title = title;
  $('header #title').text(title)
}
function update_bookings(group, push){
  var api_url = '/api/b/g/' + group;
  if(api_url){
    $.getJSON(api_url, function(data){
      $('#' + meta.id ).replaceWith( ich.structure(meta) );

      $('.day-header').click(function(){
        var div = $('#' + $(this).data('bookings-list'));
        if(div.is(':hidden')){
          $('.bookings').hide();
          div.toggle();
        }else{
          div.toggle();
        }
      });

      $.each(data, function(index, elem) {
        html = ich.booking(elem)
        var div = $('#bookings-' + elem.timeslot.day.name + '-' + elem.timeslot.label.replace(':',''));
        if(div.is(':empty')){
          div.append('<h4>' + elem.timeslot.label + '</h4>');
        }
        div.append(html);
      });
      var title = 'Bookings for ' + group;
      update_page_title(title);

      if(push){
        history.pushState({'group': group}, title, '/bookings/g/' + group );
      }
    });
  }
}
