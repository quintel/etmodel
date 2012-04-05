/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/accordion.coffee
 */

(function() {

  $(document).ready(function() {
    var accordion, e, i, open_slide_index, slide, slide_index, slide_key, slide_keys, _i, _len, _ref;
    accordion = $('.accordion').accordion({
      header: '.headline',
      collapsible: true,
      fillSpace: false,
      autoHeight: false,
      active: false
    });
    slide_keys = [];
    i = 0;
    _ref = $('li.accordion_element', this);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      e = _ref[_i];
      if ($(e).is('.selected')) open_slide_index = i;
      $(e).show();
      i += 1;
      slide_key = $(".headline", e).data('slide');
      slide_keys.push("#" + slide_key);
    }
    if (slide = window.location.hash) {
      slide_index = slide_keys.indexOf(slide);
      if (slide_index === -1) slide_index = open_slide_index;
    } else {
      slide_index = open_slide_index;
    }
    $('.ui-accordion').accordion("activate", slide_index);
    $('.ui-accordion').bind('accordionchange', function(ev, ui) {
      var output_element_id, slide_title;
      slide_key = ui.newHeader.data('slide');
      window.location.hash = slide_key;
      slide_title = $.trim(ui.newHeader.text());
      Tracker.track({
        slide: slide_title
      });
      if (ui.newHeader.length > 0) {
        output_element_id = parseInt(ui.newHeader.attr('id').match(/\d+$/));
        if (output_element_id === 32) return;
        window.charts.current_default_chart = output_element_id;
        if (!!window.charts.user_selected_chart) {
          if (window.charts.user_selected_chart === output_element_id) {
            window.charts.user_selected_chart = null;
            $("a.default_charts").hide();
          }
        } else {
          window.charts.load(output_element_id);
          return $("a.default_charts").hide();
        }
      }
    });
    return $(".slide").each(function(i, slide) {
      return $("a.btn-done", slide).filter(".next, .previous").click(function() {
        var _ref2;
        accordion.accordion("activate", i + ((_ref2 = $(this).is(".next")) != null ? _ref2 : {
          1: -1
        }));
        return false;
      });
    });
  });

}).call(this);
