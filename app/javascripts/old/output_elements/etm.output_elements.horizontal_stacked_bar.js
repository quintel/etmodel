// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html
function InitializeHorizontalStackedBar(id,series,ticks,show_point_label,unit,axis_values,colors,labels){

  // setup the default serie settings
  var series_defaults = {
    renderer: $.jqplot.BarRenderer,
    pointLabels:{show:show_point_label},
    rendererOptions: {
      barDirection: 'horizontal',
      varyBarColor: true,
      barPadding: 8,
      barMargin: 30,
      shadow: shadow
    }
  };
  
  // setup the x-axis settings
  var xaxis = {
    min: axis_values[0], // axis values are still used in this chart type because of the ability to set them in the database.
    max: axis_values[1], // ^^      ^^
    numberTicks: 5,
    tickOptions: {
      formatString: '%.2f'+unit,
      fontSize: '10px'
    }
  };
  
  $.jqplot(id, series, {
    stackSeries: true,
    seriesColors: colors,
    grid: default_grid,
    legend: create_legend(6,'s',ticks),
    seriesDefaults: series_defaults,
    axes: {
      yaxis: {
        renderer: $.jqplot.CategoryAxisRenderer,
        ticks: labels        
      },
      xaxis: xaxis
    }
  });
}