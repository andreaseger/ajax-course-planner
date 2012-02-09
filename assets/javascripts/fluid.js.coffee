#= require fluid.solver
#= require fluid.display.ascii
#= require_self

jQuery(document).ready ($) ->
  unless $.browser.msie and parseInt($.browser.version, 10) < 9
    fluid = new FluidField()
    el = document.getElementById("fluid")
    $(window).resize((e) ->
      glyphDims = (->
        $dummy = $(el).clone().text("M").css(visibility: "hidden").appendTo("body")
        retval =
          width: $dummy.width()
          height: parseInt($dummy.css("line-height"), 10)

        $dummy.remove()
        retval
      )()
      fluid.setResolution Math.round($(window).height() / glyphDims.height), Math.round($(window).width() / glyphDims.width)
    ).trigger "resize"
    display = new FluidDisplayASCII(fluid)
    display.bindElement el
    displayFPS = ->
      frames = 0
      time_start = new Date()
      $DOMfps = $("#fps")
      $DOMfps.show()
      (frame) ->
        time_end = new Date()
        frames++
        if (time_end - time_start) >= 1000
          $DOMfps.text "fps: " + Math.round((1000 * frames / (time_end - time_start)))
          time_start = time_end
          frames = 0

    fluid.setIterations 5
    display.Config.density = 180
    display.Animation.start()
###
  $("#main").hide().fadeTo "slow", 1
  $("#clear").mousedown (e) ->
    $el = $(el)
    $el.addClass("fading").fadeOut "medium", ->
      fluid.reset()
      $el.removeClass("fading").fadeIn "fast"

  (->
    $body = $("body")
    $hackermode = $("#hackermode")
    text = undefined
    $hackermode.mousedown (e) ->
      $body.toggleClass "hackermode"
      text = $hackermode.text()
      unless text.search("hacker") is -1
        text = text.replace("hacker", "designer")
      else
        text = text.replace("designer", "hacker")
      $hackermode.text text
  )()
###
