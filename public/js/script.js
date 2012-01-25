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
        $('<ul/>', {
          id: 'bookings-list'
        })
      );
      $.each(data, function(index, elem) {
        html = ich.booking(elem)
        $('#bookings-list').append(html);
      });

    });
  }
}
