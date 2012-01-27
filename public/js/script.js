/* Author: sch1zo

*/

$(function(){
  $.getJSON('/templates.json', function (data) {
    $.each(data.templates, function (i,template) {
      ich.addTemplate(template.name, template.template);
    });
    $.each(data.partials, function (i,template) {
      ich.addTemplate(template.name, template.template);
    });
  });
  update_bookings($('#bookings-list').data('api-url'));
});

function update_bookings(api_url){
  if(api_url){
    $.getJSON(api_url, function(data){
      $('#bookings-list').replaceWith(
        $('<div/>', {
          id: 'bookings-list'
        })
      );
      $.each({'mo': 'Montag', 'di': 'Dienstag', 'mi': 'Mittwoch', 'do': 'Donnerstag', 'fr': 'Freitag' }, function(key,value){
        html = $('<ul/>',{
                  id: 'bookings-' + key,
                  html: '<h3>' + value + '</h3>'
                });
        $('#bookings-list').append(html);
      });
      $.each(data, function(index, elem) {
        html = ich.booking(elem)
        switch(elem.timeslot.day.name){
        case 'mo':
          $('#bookings-mo').append(html);
          break;
        case 'di':
          $('#bookings-di').append(html);
          break;
        case 'mi':
          $('#bookings-mi').append(html);
          break;
        case 'do':
          $('#bookings-do').append(html);
          break;
        case 'fr':
          $('#bookings-fr').append(html);
          break;
        default:
        }
      });
    });
  }
}
