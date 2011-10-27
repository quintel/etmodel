// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html
function InitializeLine(id,series,unit,colors,labels){
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
    
  // setup the y-axis settings
  y2axis = {
    rendererOptions: { 
      forceTickAt0: true // we always want a tick at 0  
    },
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
