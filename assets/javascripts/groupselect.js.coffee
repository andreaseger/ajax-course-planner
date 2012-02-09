class @Group
  @build_groupselect: ->
    $.getJSON '/api/g', (data) =>
      current = $("##{meta.id}").data('group')
      $('#groupselect').replaceWith ich.groupselect(data)
      $('#groups').val current

###
function get_groups(){
  $.getJSON('/api/g',function(data){
    var current = $('#' + meta.id).data('group');
    $('#groupselect').replaceWith( ich.groupselect(data) )
    $('#groups').val(current);
  });
}
###
