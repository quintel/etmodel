var active_slide;
var open_slide_index;

$(document).ready(function() {

  $('.accordion').each(function(i,el) {

    $('li.accordion_element', this).each(function(i,el) {
      if ($(el).is('.selected')) { open_slide_index = i; }
      $(el).show();
    });

    var accordion = {};
    if ($('li.accordion_element').length > 1){
        accordion = $(el).accordion({
        header: '.headline',
        collapsible: true,
        fillSpace: false,
        autoHeight: false,
        active: false
      });
    } else {
      accordion = $(el).accordion({
        header: '.headline',
        collapsible: true,
        fillSpace: false,
        autoHeight: false
      });
    }

    // Here we load the new default chart
    $('.ui-accordion').bind('accordionchange', function(ev,ui) {
      var slide_title = $.trim(ui.newHeader.text());
      Tracker.track({slide: slide_title});
      if (ui.newHeader.length > 0){
        var output_element_id = parseInt(ui.newHeader.attr('id').match(/\d+$/));

        if(output_element_id == 32) { return; }

        window.charts.current_default_chart = output_element_id;
        // if the user has selected a chart then we keep showing it
        if(!!window.charts.user_selected_chart) {
          // if the user selected chart is the default chart for the slide then
          // let's go back to the standard behaviour, ie show the default chart
          // whenever we click on a new slide
          if(window.charts.user_selected_chart == output_element_id) {
            window.charts.user_selected_chart = null;
            $("a.default_charts").hide();
          }
          return;
        } else {
          // otherwise the chart has to be shown
          window.charts.load(output_element_id);
          $("a.default_charts").hide();
        }
      }
    });

    $(".slide").each(function(i, slide) {
      $("a.btn-done", slide).filter(".next, .previous").click(function() {
        accordion.accordion("activate",i + ($(this).is(".next") ? 1 : -1));
        return false;
      });
    });
  });

  // open default/requested slide
  if (_.isNumber(open_slide_index)){
    $('.ui-accordion').accordion( "activate" , open_slide_index);
  }

});
