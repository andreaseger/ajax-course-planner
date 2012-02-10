jQuery(document).ready(function($) {
  // forget about IE, just forget about it
  if (!($.browser.msie && parseInt($.browser.version, 10) < 9)) {

    var fluid
      , el
      , display
      , displayFPS

    // physics solver
    fluid = new FluidField();


    // display DOM element
    el = document.getElementById('fluid');

    $(window)
      .resize(function(e) {
        var glyphDims = (function() {
          var $dummy = $(el).clone().text('M').css({visibility: 'hidden'}).appendTo('body');
          var retval = {
            width:  $dummy.width(),
            height: parseInt( $dummy.css('line-height'), 10 ) // more reliable than height()
          };
          $dummy.remove();
          return retval;
        })();
        glyphDims = {width: 16, height: 19};
        // this won't be perfect, as the screen dims won't often be evenly disible
        fluid.setResolution(Math.round($(window).height() / glyphDims.height), Math.round($(window).width() / glyphDims.width));
      })
      .trigger('resize');

    // display component
    display = new FluidDisplayASCII(fluid)
    display.bindElement(el)

    displayFPS = function() {
      var frames = 0
        , time_start = new Date()
        , $DOMfps = $('#fps')

      $DOMfps.show()

      return function(frame) {
        var time_end = new Date()
        frames++
        if ((time_end - time_start) >= 1000) {
          $DOMfps.text('fps: ' + Math.round((1000 * frames / (time_end - time_start))))

          time_start = time_end
          frames = 0
        }
      }
    }

    // final configuration
    //fluid.setIterations(15);
    //display.Config.density = 260;
    fluid.setIterations(5)
    display.Config.density = 180

    display.Animation.start( /*displayFPS()*/ )
  }

  // rest of initation
  $('#main').hide().fadeTo('slow', 1)
  $('#clear').mousedown(function(e) {
    var $el = $(el)
    $el
      .addClass('fading')
      .fadeOut('medium', function() {
        fluid.reset()
        $el
          .removeClass('fading')
          .fadeIn('fast')
      })
  })

  // hackermode
  ;(function() {
    var $body = $('body')
      , $hackermode = $('#hackermode')
      , text

    $hackermode.mousedown(function(e) {
      $body.toggleClass('hackermode')

      text = $hackermode.text()
      if (text.search("hacker") != -1) {
        text = text.replace("hacker", "designer")
      }
      else {
        text = text.replace("designer", "hacker")
      }
      $hackermode.text(text)
    })
  }())
})
