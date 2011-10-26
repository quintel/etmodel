// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html

function InitializeVerticalBar(id,series,ticks,serie_settings_filler,show_point_label,unit,colors,labels){
  InitializeVerticalStackedBar(id,series,ticks,serie_settings_filler,show_point_label,unit,colors,labels);
}

function InitializeVerticalStackedBar(id,series,ticks,serie_settings_filler,show_point_label,unit,colors,labels){
  var legend_cols = 3;

  // setup the y-axis
  y2axis = {
    borderColor:'#cccccc', // color for the marks #cccccc is the same as the grid lines
    rendererOptions: { 
      forceTickAt0: true // we always want a tick a 0  
    },
    tickOptions:{
      formatString:'%.1f'+unit
    }
  };
  
  // setup the x-axis
  xaxis = {
    renderer: $.jqplot.CategoryAxisRenderer,
    ticks: ticks,
    tickOptions:{
      showMark: false, // no marks on the x axis
      showGridline: false // no vertical gridlines
    }
  };

  // setup the series defaults
  series_defaults = {
    shadow: shadow,
    renderer: $.jqplot.BarRenderer,
    rendererOptions: {
      barPadding: 0 ,
      barMargin: 110,
      barWidth: 80
    },
    pointLabels:{ // a pointlabel is a value shown besides the serie inside the grid.
      show: show_point_label, // want to show point labels?
      stackedValue: true, // sum the values of all the series in one point label
      formatString: '%.1f'
    },
    yaxis:'y2axis' // use the right side of the chart for the y-axis
  };
  
  $.jqplot(id, series, {
    grid: default_grid,
    legend: create_legend(legend_cols,'s',labels),

    stackSeries: true,
    seriesColors: colors,
    seriesDefaults: series_defaults,
    series: apply_target_line_serie_settings(serie_settings_filler),

    axes: {
      xaxis: xaxis,
      y2axis: y2axis
    }
  });
}

function apply_target_line_serie_settings(serie_settings_filler){
  // add the target line settings to the series.
  // when the target line is the 5th serie in the charts, the serie_settings_filler will look like this: [{},{},{},{}]
  // this means that the settings of the first 4 series wont be changed.
  var result;
  if (serie_settings_filler.length > 0){
    var target_serie_settings = [
      {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:true},
      {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:false}
    ];
    result = serie_settings_filler.concat(target_serie_settings);
  }
  else{
    result = [];
  }
  return result;
}