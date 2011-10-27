// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html
function InitializeMekko(id,series,unit,colors,labels,group_labels){  
  // setup needed vars
  var series_default;
  var xaxis;
  var border_color = '#999999';
  var border_width = 0.1;
  var x2axis;
  var axis_defaults;
  var legend_offset = 155;

  // setup default axis settings
  axis_defaults = {
    renderer:$.jqplot.MekkoAxisRenderer,
    tickOptions:{
      fontSize: font_size,
      markSize: 0
    }
  };
  
  // setup the top axis settings
    // added a css rotate rule in jqplot.css to tilt the top labels
  x2axis = {
    show: true,
    tickMode: 'bar'
  };
  
  // setup the bottom axis settings
  xaxis = {
    barLabels: group_labels,
    rendererOptions: {
      barLabelOptions: {
        fontSize: font_size,
        angle: -45
      },
      barLabelRenderer: $.jqplot.CanvasAxisLabelRenderer
    },
    tickOptions:{
      formatString:'&nbsp;' // hide the ticks on this axis by formatting the value as a space
    }
  };
  
  // setup default serie settings
  series_default = {
    renderer:$.jqplot.MekkoRenderer,
    rendererOptions: {
      borderColor: border_color
    }
  };
  
  
  // call jqplot and apply the settingsgroups
  $.jqplot(id, series, {
    grid: default_grid,
    legend: create_legend(3,'s',labels,legend_offset),
    seriesDefaults: series_default,
    seriesColors: colors,
    axesDefaults: axis_defaults,
    axes:{
      xaxis: xaxis,
      x2axis: x2axis
     }
  });
  
  $(".jqplot-xaxis").css({"margin-left": -10,"margin-top":0});
  $(".jqplot-table-legend").css({"top": 340});
  

}