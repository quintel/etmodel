function InitializeMekko(id,series,unit,axis_values,colors,labels){  
  var number_of_ticks = 6;
  var series_default;
  var xaxis;
  var border_color = '#999999';
  var border_width = 0.1;
  var x2axis;
  var axis_defaults;
  var legend_offset = 55;
  font_size = "12px";
  axis_defaults = {
    renderer:$.jqplot.MekkoAxisRenderer,
    tickOptions:{
      fontSize: font_size,
      markSize: 0
    }
  };
  
  x2axis = { // top axis
    show: true,
    tickMode: 'bar',
    autoscale: true,
    min: axis_values[0],
    tickSpacing: (517 / axis_values[1]) * (axis_values[1] / 9),
    numberTicks: 4,
    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
    tickOptions:{
      formatString:'%.0f'+unit,
      angle: -45,
      markSize: 4,
      fontSize: font_size
    },
    borderWidth: border_width,
    borderColor: border_color
  };

  xaxis = { // bottom axis
    barLabels: labels[1],
    rendererOptions: {
  	    barLabelOptions: {
  	        fontSize: font_size,
  	        angle: -45
  	    },
  	    barLabelRenderer: $.jqplot.CanvasAxisLabelRenderer
  	},
    tickOptions:{
      formatString:'&nbsp;' // ugly but it works
    }
  };
  
  series_default = {
    renderer:$.jqplot.MekkoRenderer,
    shadow:shadow,
    pointLabels:{show:false},
    rendererOptions: {
      showBorders: true,        // Note, true is the default
      borderColor: '#4c4130'
    }
    
  };
  
  $.jqplot(id, series, {
    grid: default_grid,
    legend: create_legend(3,'s',labels[0],legend_offset),
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