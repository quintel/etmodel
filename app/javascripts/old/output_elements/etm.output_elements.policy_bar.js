function InitializePolicyBar(id,serie1,serie2,ticks,groups,unit,axis_values,colors,labels){
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

function InitializeGroupedVerticalBar(id,series,ticks,filler,groups,unit,axis_values,colors,labels){
  if (filler.length > 0){
      var fil_lines = [
        {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:false, color:'#FF0000'},
        {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:false, color:'#FF0000'},
        {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:false, color:'#FF0000'},
        {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:false, color:'#FF0000'}
      ];
      var fil = filler.concat(fil_lines);
    }
    else{
      var fil = [];
    }
  var series_default;
  var serie_colors;
  var axes_defaults;
  var x_tick_options;
  var y_tick_options;
  var renderer_options;
  // this hack will push the labels for the top series off of the page so they don't appear.  
  // series_with_hack = [{pointLabels:{ypadding: 999,hideZeros: false}},{pointLabels:{ypadding:9000}}];
  
  renderer_options = {
    
    barWidth: 60, 
    // barPadding: 10, 
    barMargin: 10,
    fillToZero: true,
    shadow: false,
    varyBarColor: true,
    useNegativeColors: false//,
    // groups: 2  
  };
  
  series_default = {
      lineWidth: 1.5,
      shadow:shadow,
      renderer: $.jqplot.BarRenderer,
      pointLabels:{
        show: false,
        formatString: '%.1f'
      },
    renderer: $.jqplot.BarRenderer,
    rendererOptions: renderer_options,
    yaxis:'y2axis'
  };
  serie_colors = colors.concat(colors);
  axes_defaults =  {tickOptions: {fontSize:font_size}};
  x_tick_options = {showGridline:false,markSize:1,pad:4.0};
  y_tick_options = {showGridline:true, formatString:'%d'+unit};
  $.jqplot(id, series, {
    grid: default_grid,
      stackSeries: true, 
      legend: create_legend(2,'s', ["Fossil", "Renewable", "Demand"],50),
      seriesColors: serie_colors,
      seriesDefaults: series_default,
      series: fil,
      axesDefaults: axes_defaults,
      axes: {
        xaxis:{
          pad: 15.00,
          ticks: ["2010","2040","2010","2040"],
           rendererOptions: {
             groupLabels: ["Electricity","Heat"]
           },
          renderer: $.jqplot.CategoryAxisRenderer, 
          tickOptions: x_tick_options
        },
        y2axis:{
          // autoscale: true,
          shadow: false,
          min:axis_values[0],
          numberTicks:6,
          max:axis_values[1],
          pad: 15.00,
          // ticks: axis_values, 
          tickOptions: y_tick_options
        }
      }
  });
  $(".jqplot-point-label:contains('null')").hide();
}

