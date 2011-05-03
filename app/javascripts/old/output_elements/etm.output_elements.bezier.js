var growth;
var legend;
var series_default;
var x_axis;
var y_axis;
var y2_axis;
var format_string = '%.0f&nbsp;';
series_default = {
  renderer:$.jqplot.BezierCurveRenderer,
  lineWidth: 1.5,
  shadow: false,
  pointLabels:{show:false},
  // fill: true,
  border: false, 
  fillToZero: true,
  fillToValue: 0, // no white spaces
  showMarker: true,
  yaxis:'y2axis'
};

x_axis = {
  showTickMarks:false, 
  borderWidth:1,
  borderColor:'#999999',
  numberTicks:2,
  tickOptions:{
    showGridline: false
  }
};

y_axis = {
  tickOptions:{
    showTickMarks:true, 
    showMarks:true, 
    markSize:4,
    borderWidth: 0.5,
    borderColor:'#999999'
  }
};

function InitializeBezier(id,series,growth,unit,axis_values,colors,labels){
  var decimals = 0;
  if (axis_values[1] < 10 && axis_values[1] != 5 && axis_values[1] > 0 ){
    decimals = 1;
  }


  y2_axis = {
    borderWidth:0.1,
    borderColor:'#999999',
    shadow: false,
    autoscale: true,
    min: 0,//axis_values[0],
    numberTicks: 6,
    max: axis_values[1],
    pad:15.00,
    labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
    tickOptions:{
      showTickMarks:true, 
      showMarks:true, 
      markSize:4,
      formatString: '%.'+decimals+'f'+unit
    }
  };
 

  var start_x = series[0][0][0]; // get the start year
  var end_x = series[0][1][0]; // get the end year
  var plotted_series = [];
  var start_value = 0;
  var end_value = 0;
  // var use_user_value = false;
  $.each(series, function(index, serie) { 
    var start_y = serie[0][1];
    start_value += start_y;
    var end_y = serie[1][1];
    end_value += end_y;
    var start_percentage;
    var end_percentage;
    
    if (growth){
      if(start_value > end_value) {
        start_percentage = 51;
        end_percentage = 0;
      }
      else{
        start_percentage = 100;  
        end_percentage = 51;
      }
    }
    else {
      if(start_value > end_value) {
        start_percentage = 50 + ((end_x - start_x)/2);
        end_percentage = 0;
      }
      else{
        start_percentage = 0;  
        end_percentage = 50 + ((end_x - start_x)/2);
      }
    }
    plotted_series.push([[start_x, start_value], set_handles(start_x,end_x,start_value,end_value,start_percentage,end_percentage).concat([end_x, end_value])]);
  });

    
    // console.log(plotted_series[0][1]);
    // plotted_series[0][1] = [2018.00001, 89.11001, 2030.00001, 0, 2050, 0];
    //     console.log(plotted_series[0][1]);
  start_value = 0;
  end_value = 0;
  plot = $.jqplot(id, plotted_series, {
    seriesColors: colors,
    grid: default_grid,
    legend: create_legend(2,'s',labels),
    // use the new fillToValue option to make filled series "hover" above the x axis.
    stackSeries: false,    
    seriesDefaults: series_default,
    axesDefaults: stacked_line_axis_default,
    axes:{ 
      xaxis: x_axis,
      yaxis: y_axis,
      y2axis: y2_axis,
      x2axis: {
        borderWidth:0,
        borderColor:'#ffffff'
      },
      yaxis: {
        borderWidth: 1,
        borderColor: '#999999'
      }
    }
  });
  
  // console.log(plot.series[0]._xaxis._ticks[0])
}

function set_handles(start_x,end_x,start_y,end_y,start_percentage,end_percentage) {
  var half_x = ((end_x - start_x) / 2) + start_x;
  
  var handle_1_x = get_handle_1_x(half_x,start_x,end_x,start_percentage,end_percentage)+0.00001;
  var handle_2_x = get_handle_2_x(start_x,half_x,end_x,start_percentage,end_percentage,start_y,end_y)+0.00001;
  
  var handle_1_y = start_y+0.00001 ;
  var handle_2_y = end_y+0.00001; 

  return [handle_1_x,handle_1_y,handle_2_x,handle_2_y];
}

function get_handle_1_x(half_x,start_x,end_x,start_percentage,end_percentage) {
  if (end_percentage < 50){
    if (start_percentage < 50){
      if (start_percentage > end_percentage){
        return start_x;
      }
      else{
        return (half_x - ((start_percentage / 100) * (end_x - start_x)));   
      }
    }
    else{
     return (half_x - ((end_x - start_x) - ((start_percentage / 100) * (end_x - start_x))));
    }
  }
  else{
    if (start_percentage < 50) {
      return (half_x - ((start_percentage / 100) * (end_x - start_x)));
    }
    else{
      if (start_percentage < end_percentage) {
        return start_x;        
      }
      else{
        return (end_x - ((end_percentage / 100) * (end_x - start_x)));
      }
    }
  }
}

function get_handle_2_x(start_x,half_x,end_x,start_percentage,end_percentage) {
 if (end_percentage < 50) {
   if (start_percentage < 50) {
     if (start_percentage > end_percentage) {
       return end_x - ((start_percentage / 100) * (end_x - start_x));
     }
     else {
       return end_x;
     }
   }
   else{
     return (half_x + ((end_percentage / 100) * (end_x - start_x)));
   } 

 }
 else{
   if (start_percentage < 50) {
     //   console.log ('ajajaj'+ growth);


     valu = (half_x + ((end_x - start_x) - ((end_percentage / 100) * (end_x - start_x))));
     return valu;
   }
   else{
     if (start_percentage > end_percentage ){
       return end_x;
     }
     else{
       return half_x + ((end_x - start_x) - ((end_percentage / 100) * (end_x - start_x)));
     }
   }
 }
}