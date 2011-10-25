// setup needed vars
var series_default;
var y2_axis;


function InitializeBezier(id,series,growth,unit,axis_values,colors,labels){
  var decimals = 0;
  if (axis_values[1] < 10 && axis_values[1] != 5 && axis_values[1] > 0 ){
    decimals = 1;
  }

  y2_axis = {
    borderColor:'#CCCCCC', // color for the marks #cccccc is the same as the grid lines
    min: 0,
    max: axis_values[1],
    numberTicks: 6,
    tickOptions:{
      formatString: '%.'+decimals+'f'+unit
    }
  };

  series_default = {
    renderer:$.jqplot.BezierCurveRenderer,
    pointLabels:{show:false},
    yaxis:'y2axis'
  };


  var start_x = series[0][0][0]; // get the start x, this is the present year
  var end_x = series[0][1][0]; // get the end x, this is the future year
  var ticks = [start_x,end_x]; // set years as ticks 
  
  var plotted_series = plot_series(series,start_x,end_x,growth); // plot the series

  plot = $.jqplot(id, plotted_series, {
    grid: default_grid,
    legend: create_legend(2,'s',labels),

    stackSeries: false, // this must be false! The series are stacked by summing the y-values
    seriesDefaults: series_default,
    seriesColors: colors,

    axesDefaults: stacked_line_axis_default,
    axes:{ 
      xaxis: {
        numberTicks: 2, // only show present and future year
        tickOptions:{
          showGridline: false
        },
        ticks: ticks
      },
      y2axis: y2_axis
    }
  });
  
}

// RD: check http://alecjacobson.com/programs/bezier-curve/ for a nice bezier drawing tool!

function plot_series(series,start_x,end_x,growth){
  var result = [];
  var start_value = 0;
  var end_value = 0;

  
  $.each(series, function(index, serie) { 
    var start_y = serie[0][1]; // get the present value of the serie
    start_value += start_y; // the series are stacked, so sum the present value of the serie with the previous series.

    var end_y = serie[1][1]; // get the future value  of the serie
    end_value += end_y; // the series are stacked, so sum the future value of the serie with the previous series.
    
    if (growth){ // when the chart must display an exponential growth or exponential decrease render only 50% of the s curve
      if(start_value > end_value) {
        result.push([[start_x, start_value], set_decrease_ex_curve(start_x,end_x,start_value,end_value).concat([end_x, end_value])]);      
      }
      else{
        result.push([[start_x, start_value], set_growth_ex_curve(start_x,end_x,start_value,end_value).concat([end_x, end_value])]); 
      }
    }
    else {
      result.push([[start_x, start_value], set_s_curve(start_x,end_x,start_value,end_value).concat([end_x, end_value])]);
    }
  });
  
  return result;
}

function set_s_curve(start_x,end_x,start_y,end_y) {
  // RD: see https://img.skitch.com/20111025-cdxwbfqxehwhm92mcayb9xnj93.jpg for a visual
  var start_handle_x = start_x + ((end_x - start_x) / 2);
  var start_handle_y = start_y;

  var end_handle_x = end_x - ((end_x - start_x) / 4);
  var end_handle_y = end_y; 

  return [start_handle_x,start_handle_y,end_handle_x,end_handle_y];
}

function set_growth_ex_curve(start_x,end_x,start_y,end_y) {
  // RD: see https://img.skitch.com/20111025-q6jwcg56afy6gx5pc2esynrk3m.jpg for a visual
  var start_handle_x = start_x + ((end_x - start_x) / 2);
  var start_handle_y = start_y;
  
  var end_handle_x = end_x;
  var end_handle_y = end_y; 

  return [start_handle_x,start_handle_y,end_handle_x,end_handle_y];
}

function set_decrease_ex_curve(start_x,end_x,start_y,end_y) {
  // RD: see https://img.skitch.com/20111025-mwbkap2s6axuwqiemc6hpiswjw.jpg for a visual
  var start_handle_x = start_x + ((end_x - start_x) / 2);
  var start_handle_y = end_y;
  var end_handle_x = end_x;
  
  var end_handle_y = end_y; 

  return [start_handle_x,start_handle_y,end_handle_x,end_handle_y];
}

