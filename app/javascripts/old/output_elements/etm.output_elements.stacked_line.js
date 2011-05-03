function InitializeLine(id,series,axis_values,colors,labels,unit) {
  var tick_number = 5;
  var max_value = axis_values[1];
  var min_value = axis_values[0];
  
  if (min_value < 0 ){
    var extra_ticks = Math.ceil((min_value * -1) / (max_value / tick_number));
    min_value = 0 - (max_value / tick_number * extra_ticks );
    tick_number += (extra_ticks + 1);
  }
  else {
    tick_number = 6;
  }
  
  var decimals = 0;
  
  if (axis_values[1] < 10 && axis_values[1] != 5){
    decimals = 2;
  }
  
  var series_default = {
    lineWidth: 1.5,
    shadow:shadow,
    fill: true,
    pointLabels:{show:false},
    fillToZero: true,
    showMarker: true,
    yaxis:'y2axis'
  };

  var xaxis = {
    showTickMarks:false, 
    borderWidth:1,
    borderColor:'#999999',
    ticks:[series[0][0][0], series[0][1][0]],
    tickOptions:{
      showGridline: false
    }
  };

  var y2axis = {
    borderWidth:0,
    borderColor:'#ffffff',
    autoscale: false,
    shadow: false,
    min:min_value,
    numberTicks:tick_number,
    max:max_value,
    pad:15.00,
    tickOptions:{
      showTickMarks:true, 
      showMarks:true, 
      markSize:4,
      formatString:'%.'+decimals+'f&nbsp;'+unit
    }
  };


  $.jqplot(id, series, {
    seriesColors: colors,
    grid: default_grid,
    legend: create_legend(2,'s',labels),
    stackSeries: true,
    seriesDefaults: series_default,
    axesDefaults: stacked_line_axis_default,
    series: [{fillToZero: true},{fillToZero: true},{fillToZero: true},{fillToZero: false},{fillToZero: false},{fillToZero: false}],
    axes:{ 
      xaxis: xaxis,
      y2axis: y2axis,
      x2axis: line_x2axis
    }
  });
}

function InitializeStackedLine(id,name,series,labels,colors,tick_size,min_value){
  InitializeLine(id,name,series,labels,colors,tick_size,true,min_value);
}