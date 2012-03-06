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

// PZ: This globals have been copied to BaseChartView
// they can be removed when all the charts will be converted
// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html
// default settings for output elements
var font_size = '11px';
var shadow = false;

var default_grid = {
    drawGridLines: false,       // wether to draw lines across the grid or not.
    gridLineColor: '#cccccc',    // Color of the grid lines.
    background: '#ffffff',      // CSS color spec for background color of grid.
    borderColor: '#cccccc',     // CSS color spec for border around grid.
    borderWidth: 0.0,           // pixel width of border around grid.
    shadow: shadow              // draw a shadow for grid.
}

function create_legend(columns,location,labels,offset) {
  var legend_offset = 25;
  if (offset){
    legend_offset = offset;
  }
  var legend = {
    renderer: $.jqplot.EnhancedLegendRenderer,
    show: true,
    location: location,
    fontSize: font_size,
    placement: "outside",
    labels: labels,
    yoffset: legend_offset,
    rendererOptions: {
       numberColumns: columns,
       seriesToggle: false
    }
  };
  
  return legend;
}

var stacked_line_axis_default = {
  tickOptions: {
    formatString: '%d',
    fontSize:font_size
  }
};
