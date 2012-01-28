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
  update_bookings($('#' + meta.id ).data('group'), false);
  get_groups();
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
function update_bookings(group, push){
  var api_url = '/api/b/g/' + group;
  if(api_url){
    $.getJSON(api_url, function(data){
      $('#' + meta.id ).replaceWith( ich.structure(meta) );

      $('.day-header').click(function(){
        $('#' + $(this).data('bookings-list')).toggle();
      });

      $.each(data, function(index, elem) {
        html = ich.booking(elem)
        $('#' + elem.timeslot.day.name + ' .bookings').append(html);
      });
      if(push){
        history.pushState({'group': group}, 'Bookings for ' + group, '/bookings/g/' + group );
      }
    });
  }
}
