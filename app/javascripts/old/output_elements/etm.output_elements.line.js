// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html
function InitializeLine(id,series,unit,axis_values,colors,labels){
  // setup needed vars
  var legend_offset = 20;
  var series_default;
  var axes_defaults;
  var xaxis;
  var y2axis;
  var decimals = 0;

  // setup the default serie settings
  series_default = {
    lineWidth: 1.5,
    showMarker: false,
    yaxis:'y2axis'
  };
  
  // setup the x-axis settings
  xaxis = {
    numberTicks:2,    
    tickOptions:{
      fontSize: font_size,
      showGridline: false
    }
  };

  // define the number of decimals
  if (axis_values[1] < 10 && axis_values[1] != 5){
    decimals = 2;
  }
    
  // setup the y-axis settings
  y2axis = {
    min: axis_values[0],
    max: axis_values[1],
    numberTicks: 6,    
    tickOptions: {
      formatString:'%.'+decimals+'f&nbsp;'+unit
    }
  };
  
  $.jqplot(id, series, {
    seriesColors: colors,
    grid: default_grid,
    legend: create_legend(2,'s',labels,legend_offset),
    seriesDefaults: series_default,
    axes:{ 
      xaxis: xaxis,
      y2axis: y2axis
    }
});
}
