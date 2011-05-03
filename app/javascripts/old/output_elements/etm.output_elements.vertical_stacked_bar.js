function InitializeVerticalBar(id,series,ticks,filler,show_point_label,unit,axis_values,colors,labels){
  InitializeVerticalStackedBar(id,series,ticks,filler,show_point_label,unit,axis_values,colors,labels);
}
function InitializeVerticalStackedBar(id,series,ticks,filler,show_point_label,unit,axis_values,colors,labels){
    console.info(series.length);
    console.info(filler.length);
  var max_value = axis_values[1];
  var min_value = axis_values[0];

  tick_number = 4;
  if (max_value < 0 ){
    var extra_ticks  = Math.ceil((min_value * -1) / (max_value / tick_number));
    min_value = -100 - (max_value / tick_number * extra_ticks );
    tick_number += (extra_ticks + 1);
  }
  else {
    tick_number = 6;
  }

  var cols = 3;
  var show_label = true;
  var location = 's';
  // var target_color = '#E07033';
  var decimals = 0;
  
  if (axis_values[1] < 10 && axis_values[1] != 5 && axis_values[1] > 0 ){
    decimals = 1;
  }
 
  if (filler.length > 0){
    var fil_lines = [
      {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:true},
      {renderer:$.jqplot.LineRenderer, disableStack:true,lineWidth: 1.5, shadow:true, showMarker:false, showLabel:false}
    ];
    var fil = filler.concat(fil_lines);
  }
  else{
    var fil = [];
  }
  $.jqplot(id, series, {
    stackSeries: true,
    seriesColors: colors,
    grid: default_grid,
    legend:{
      renderer: $.jqplot.EnhancedLegendRenderer,
      show:true,
      location: location,
      borderWidth: 0,
      fontSize: font_size,
      placement: "outside",
      labels: labels,
      yoffset: 25,
      rendererOptions:{
        numberColumns: cols
      }
    },
    stackSeries:true,
      // use the new fillToValue option to make filled series "hover" above the x axis.
      seriesDefaults:{
        lineWidth: 1.5,
        shadow:shadow,
        renderer: $.jqplot.BarRenderer,
        rendererOptions: {
            barPadding: 0 ,
            barMargin: 110,
            barWidth: 80
        },
        pointLabels:{
          show: show_point_label,
          formatString: '%.1f'
        },

        yaxis:'y2axis'
      },
      series: fil,
      axes: {
          xaxis: {
              renderer: $.jqplot.CategoryAxisRenderer,
              ticks: ticks,
              
              tickOptions:{
                  showGridline: false,
                  showTickMarks:true, 
                  showMarks:true, 
                  markSize:0,
                  fontSize:font_size
              }
          },
         
          y2axis: {
            borderWidth:0,
            borderColor:'#ffffff',
            autoscale: false,
            pad:1.00,
            min: axis_values[0],
            numberTicks: 6,
            max: axis_values[1],        
            tickOptions:{
              formatString:'%.'+decimals+'f'+unit,
              fontSize:font_size
            }
          }
      }
  });
}