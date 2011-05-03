function InitializeHorizontalBar(id,series,show_point_label,unit,axis_values,colors,labels){
  $.jqplot(id, [series], {
    seriesColors: colors,
    grid: default_grid,
    seriesDefaults: {
      renderer: $.jqplot.BarRenderer,
      pointLabels:{show:show_point_label},
      rendererOptions: {
        barDirection: 'horizontal',
        varyBarColor: true,
        barPadding: 6,
        barMargin: 100,
        shadow: shadow
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
          formatString: '%.0f'+unit,
          fontSize: font_size
        }
      }
    }
  });
}