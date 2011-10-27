// for available options check http://www.jqplot.com/docs/files/jqPlotOptions-txt.html

function InitializePolicyBar(id,serie1,serie2,ticks,groups,unit,colors,labels){
  // setup needed vars
  var series_with_hack;
  var series_default;
  var serie_colors;
  var x_axis;
  var y_axis;

  // this hack will push the labels for the top series off of the page so they don't appear.  
  series_with_hack = [{pointLabels:{ypadding: -15}},{pointLabels:{ypadding:9000}}];

  // setup the default serie settings
  series_default = {
    renderer: $.jqplot.BarRenderer,
    rendererOptions: {
      groups: groups,
      barWidth: 35
    },
    pointLabels:{
      stackedValue: true
    },
    yaxis:'y2axis',
    shadow: shadow
  };
  
  // set the colors for the serie and the 'remainder serie'
  serie_colors = [colors[0],"#CCCCCC"];
  
  // setup the x-axis settings
  x_axis = {
    ticks: ticks,
    rendererOptions: {
      groupLabels: labels
    },
    renderer: $.jqplot.CategoryAxisRenderer, 
    tickOptions: {
      showGridline:false,
      pad:3.00
    }
  };

  // setup the y-axis settings
  y_axis = {
    ticks: [0,100], // this charts is alway a percentage
    tickOptions: {
      formatString:'%d\%'
    }
  };
  
  $.jqplot(id, [serie1,serie2], {
    grid: default_grid,
      stackSeries: true, 
      seriesColors: serie_colors,
      seriesDefaults: series_default,
      series: series_with_hack,
      axesDefaults: {
        tickOptions: {
          fontSize:font_size
        }
      },
      axes: {
        xaxis: x_axis,
        y2axis: y_axis
      }
  });
};

