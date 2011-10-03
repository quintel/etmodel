function InitializeGroupedVerticalBar(id,serie1,serie2,ticks,groups,unit,axis_values,colors,labels){
  var series_with_hack;
  var series_default;
  var serie_colors;
  var axes_defaults;
  var x_tick_options;
  var y_tick_options;
  var renderer_options;
  // this hack will push the labels for the top series off of the page so they don't appear.
  series_with_hack = [{pointLabels:{ypadding: -15}},{pointLabels:{ypadding:9000}}];
  renderer_options = {groups: groups,barWidth: 35};

  series_default = {
    renderer: $.jqplot.BarRenderer,
    rendererOptions: renderer_options,
    pointLabels:{stackedValue: true},
    yaxis:'y2axis',
    shadow: false
  };
  serie_colors = [colors[0],"#CCCCCC"];
  axes_defaults =  {tickOptions: {fontSize:font_size}};
  x_tick_options = {showGridline:false,markSize:0,pad:3.00};
  y_tick_options = {formatString:'%d\%'};

  $.jqplot(id, [serie1,serie2], {
    grid: default_grid,
      stackSeries: true,
      seriesColors: serie_colors,
      seriesDefaults: series_default,
      series: series_with_hack,
      axesDefaults: axes_defaults,
      axes: {
        xaxis:{
          ticks: ticks,
           rendererOptions: {
             groupLabels: labels
           },
          renderer: $.jqplot.CategoryAxisRenderer,
          tickOptions: x_tick_options
        },
        y2axis:{
          ticks: axis_values,
          tickOptions: y_tick_options
        }
      }
  });
}
