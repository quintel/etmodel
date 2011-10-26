// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html
function InitializeHorizontalBar(id,series,show_point_label,unit,axis_values,colors,labels){
  // setup needed vars
  var series_default;
  var xaxis;
  var yaxis;
  
  // setup the default serie settings
  series_default = {
    renderer: $.jqplot.BarRenderer,
    pointLabels:{show:show_point_label},
    rendererOptions: {
      barDirection: 'horizontal',
      varyBarColor: true,
      barPadding: 6,
      barMargin: 100,
      shadow: shadow
    }
  };

  // setup the xaxis settings
  xaxis = {
    min: axis_values[0],
    max: axis_values[1],
    numberTicks: 6,
    tickOptions: {
      formatString: '%.1f'+unit
    }
  };
  
  // setup the y-axis settings
  yaxis = {
    renderer: $.jqplot.CategoryAxisRenderer,
    ticks: labels
  };
  
  $.jqplot(id, [series], {
    seriesColors: colors,
    grid: default_grid,
    seriesDefaults: series_default,
    axes: {
      yaxis: yaxis,
      xaxis: xaxis
    }
  });
}