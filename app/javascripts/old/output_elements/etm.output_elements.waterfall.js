function InitializeWaterfall(id,series,unit,axis_values,colors,labels,ticks){
  // setup needed vars
  var bar_width = 25;
  var series_default;
  var xaxis;
  var y2axis;

  // setup the y axis settings
  y2axis = {
    rendererOptions: { 
      forceTickAt0: true // we always want a tick a 0  
    },
    tickOptions:{
      formatString: '%.0f'+'&nbsp;'+unit
    }
  };
  // setup the x axis settings  
  xaxis = {
    renderer: $.jqplot.CategoryAxisRenderer, 
    ticks:labels,
    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
    tickOptions: {
      angle: -90,
      showGridline: false
    }
  };
  // setup the serie default settings
  series_default = {
    shadow:shadow,
    renderer:$.jqplot.BarRenderer, 
    rendererOptions:{
      waterfall: true,
      varyBarColor: true,
      useNegativeColors: false,
      barWidth: bar_width
    },
    pointLabels: {
      ypadding: -5,
      formatString: '%.0f'
    },
    yaxis:'y2axis'
  };
  
  $.jqplot(id, [series], {
    seriesColors: colors,
    grid: default_grid,
    seriesDefaults: series_default,
    axes:{
      xaxis: xaxis,
      y2axis: y2axis
    }
  });
}