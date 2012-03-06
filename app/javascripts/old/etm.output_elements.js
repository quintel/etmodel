// functions for select an other charts
$(document).ready(function() {
  $.jqplot.config.enablePlugins = true;

  $("a.default_charts").live('click',function () { // it this the same as in accordion.js?
    charts.user_selected_chart = null;
    charts.load(charts.current_default_chart);
  });
  
  $(".pick_charts").live('click',function () {
    var chart_id = $(this).attr('id').match(/\d+$/);
    window.charts.user_selected_chart = chart_id;
    var url = "/output_elements/select_chart/"+ chart_id;
    $.ajax({ 
      url: url+"?"+timestamp(), 
      method: 'get',
      beforeSend: function() {
        close_fancybox();
      }
    });
  });
});
