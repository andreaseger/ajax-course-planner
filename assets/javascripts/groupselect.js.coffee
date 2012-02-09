Array::last = -> @[@.length -1]

class @GroupsBuilder
  constructor: (@list) ->

  fetch_list: ->
    $.getJSON '/api/g', (data) =>
      @list = data
  groupselect: ->
    fetch_list unless @list? and @list.length > 0
    current = window.location.pathname.split('/').last
    $('#groupselect').replaceWith ich.groupselect(@list)
    $('#groups').val current
