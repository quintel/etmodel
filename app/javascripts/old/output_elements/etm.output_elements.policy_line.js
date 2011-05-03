function InitializePolicyLine(id,series,unit,axis_values,colors,labels){
  var legend_offset = 15;
  var decimals = 0;
  var series_default = {
    lineWidth: 1.5,
    shadow:shadow,
    fill:false,
    fillToZero:true,
    pointLabels:{show:false},
    // fillToValue: tick_size / 20, // no white spaces
    showMarker: false,
    yaxis:'y2axis'
    
  };
  
  var axes_defaults = {
    showTickMarks:false, 
    tickOptions: {
      formatString: '%d',
      fontSize:font_size
    }
  };
  
  var xaxis = {
    borderWidth:1,
    borderColor:'#999999',
    // ticks:[series[0][0][0], series[0][1][0]],
    pad:1.00,
    tickOptions:{
      showGridline: false
    }
  };

  if (axis_values[1] < 10 && axis_values[1] != 5){
    decimals = 2;
  }
    
  var y2axis = {
    borderWidth:0,
    borderColor:'#ffffff',
    autoscale: false,
    min:axis_values[0],
    numberTicks:6,
    max:axis_values[1],
    pad:1.00,
    labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
    // label:'energy use',
    tickOptions:{
      formatString:'%.'+decimals+'f&nbsp;'+unit
    }
  };
  
  $.jqplot(id, series, {
    seriesColors: colors,
    grid: default_grid,
    legend: create_legend(2,'s',labels,legend_offset),
    seriesDefaults: series_default,
    axesDefaults: axes_defaults,
    axes:{ 
      xaxis: xaxis,
      y2axis: y2axis,
      x2axis: line_x2axis,
      yaxis: line_yaxis
    }
});
}