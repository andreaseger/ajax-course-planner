/* Author: sch1zo

*/

$(function(){
  update_bookings($('#bookings-list').data('api-url'));
});

function update_bookings(api_url){
  if(api_url){
    $.getJSON(api_url, function(data){
      var bookings = [];

      $.each(data, function(index, elem) {
        bookings.push('<li id="booking ' + index + '">' + elem.course.label + '</li>');
      });

      $('#bookings-list').replaceWith(
        $('<ul/>', {
          id: 'bookings-list',
          html: bookings.join('')
        })
      );
    });
  }
}
