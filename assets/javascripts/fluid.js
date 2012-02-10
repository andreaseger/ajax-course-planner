//= require fluid/fluid.solver
//= require fluid/fluid.display.ascii
//= require_self

$(function() {
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

        // this won't be perfect, as the screen dims won't often be evenly disible
        //fluid.setResolution(Math.round($(window).height() / glyphDims.height), Math.round($(window).width() / glyphDims.width));
        fluid.setResolution(Math.round(600 / glyphDims.height), Math.round($(window).width() / glyphDims.width));
      })
      .trigger('resize');

    // display component
    display = new FluidDisplayASCII(fluid)
    display.bindElement(el)

    // final configuration
    //fluid.setIterations(15);
    //display.Config.density = 260;
    fluid.setIterations(5)
    display.Config.density = 120

    //display.Animation.start( /*displayFPS()*/ )
  }
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
  $('#start').click(function(e) {
    $('#fluid').toggle();
    $('#stop').toggle();
    $('#start').toggle();
    display.Animation.start();
    fluid.reset();
  });
  $('#stop').click(function(e) {
    fluid.reset();
    display.Animation.stop();
    $('#fluid').toggle();
    $('#stop').toggle();
    $('#start').toggle();
  });

});
