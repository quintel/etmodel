// functions for select an other charts
$(document).ready(function() {
  $.jqplot.config.enablePlugins = true;
  $("a.default_charts").live('click',function () { // it this the same as in accordion.js?
    var output_element;
    var output_element_id;
    output_element = $(".ui-state-active").attr('id');
    if (output_element){
      output_element_id = output_element.match(/\d+$/);
    }
     else{
      output_element_id = $(".ui-accordion-header")[0].id.match(/\d+$/);
    }  

    var url = "/output_elements/default_chart/"+output_element_id;
    $.ajax({ 
      url: url+"?"+timestamp(),
      method: 'get'
    });
  });
  
  $(".pick_charts").live('click',function () {

    var url = "/output_elements/select_chart/"+$(this).attr('id').match(/\d+$/);
    $.ajax({ 
      url: url+"?"+timestamp(), 
      method: 'get',
      beforeSend: function() {
        $('#chart_loading').show();
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
