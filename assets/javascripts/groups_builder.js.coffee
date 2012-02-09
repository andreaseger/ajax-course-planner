class @GroupsBuilder
  constructor: (@list) ->

  fetch_list: (current) ->
    $.getJSON '/api/g', (data) =>
      @list = data
      if current?
        @groupselect(current)

  groupselect: (current) ->
    if @list? and @list.groups.length > 0
      $('#groupselect').replaceWith ich.groupselect(@list)
      $('#groups').val current
    else
      @fetch_list(current)
