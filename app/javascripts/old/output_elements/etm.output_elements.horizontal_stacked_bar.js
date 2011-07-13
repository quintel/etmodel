function InitializeHorizontalStackedBar(id,series,ticks,show_point_label,unit,axis_values,colors,labels){
  $.jqplot(id, series, {
    stackSeries: true,
    seriesColors: colors,
    grid: default_grid,
    legend: create_legend(6,'s',ticks),
    seriesDefaults: {
      renderer: $.jqplot.BarRenderer,
      pointLabels:{show:show_point_label},
      rendererOptions: {
        barDirection: 'horizontal',
        varyBarColor: true,
        barPadding: 6,
        barMargin: 40,
        shadow: false
      }
    },
    axes: {
      yaxis: {
        renderer: $.jqplot.CategoryAxisRenderer,
        ticks: labels        
      },
      xaxis: {
        min: axis_values[0],
        max: axis_values[1],
        numberTicks: 6,
        tickOptions: {
          formatString: '%.0f'+unit
        }
      }
    }
  });
}