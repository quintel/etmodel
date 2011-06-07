// functions for select an other charts
$(document).ready(function() {
  $.jqplot.config.enablePlugins = true;

  $("a.default_charts").live('click',function () { // it this the same as in accordion.js?
    charts.load(charts.current_default_chart);
  });
  
  $(".pick_charts").live('click',function () {

    var url = "/output_elements/select_chart/"+$(this).attr('id').match(/\d+$/);
    $.ajax({ 
      url: url+"?"+timestamp(), 
      method: 'get',
      beforeSend: function() {
        close_fancybox();
      }
    });
  });
});

// default settings for output elements
var font_size = '12px';
var shadow = false;

var default_grid = { 
  background: '#ffffff',
   borderWidth: 0,
   borderColor: '#ffffff',
   shadow: shadow
};

function create_legend(columns,location,labels,offset) {
  var legend_offset = 25;
  if (offset){
    legend_offset = offset;
  }
  var legend = {
    renderer: $.jqplot.EnhancedLegendRenderer,
    show: true,
    location: location,
    borderWidth: 0,
    fontSize: font_size,
    placement: "outside",
    labels: labels,
    yoffset: legend_offset,
    rendererOptions: {
       numberColumns: columns
    }
  };
  
  return legend;
}

var line_x2axis = {
  borderWidth:0,
  borderColor:'#ffffff'
};

var line_yaxis = {
  borderWidth: 0.5,
  borderColor: '#999999'
};

var stacked_line_axis_default = {
  tickOptions: {
    formatString: '%d',
    fontSize:font_size
  }
};
