// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html
function InitializeGroupedVerticalBar(id,series,ticks,groups,unit,colors,labels){

  // setup needed vars
  var series_default;
  var serie_colors;
  var axes_defaults;
  var x_axis;
  var y_axis;

  
  // renderer_options = {};

  series_default = {
    renderer: $.jqplot.BarRenderer,
    rendererOptions: {
      groups: groups,
      barWidth: 20
    },
    pointLabels:{show:false},
    yaxis:'y2axis',
    shadow: shadow
  };
  
  // serie_colors = [colors];
  
  axes_defaults =  {tickOptions: {fontSize:font_size}};
  
  x_axis = {
    ticks: ticks,
     rendererOptions: {
       groupLabels: labels
     },
    renderer: $.jqplot.CategoryAxisRenderer,
    tickOptions: {
      showGridline:false,
      markSize:0,
      pad:1.00
    }
  }
  

  y_axis = { 
    tickOptions: {
      formatString:'%d&nbsp;' + unit
    } 
  };

  $.jqplot(id, [series], {
    grid: default_grid,
    stackSeries: true,
    seriesColors: colors,
    seriesDefaults: series_default,
    axesDefaults: axes_defaults,
    axes: {
      xaxis: x_axis,
      y2axis: y_axis
    }
  });
}
