$(function(){
  
  // Chart series methods
  // Move on the server side
  //
  var calculate_value = function(x, years) {
    var base = 1 + x / 100.0;
    var out = Math.pow(base, years) * 100;
    return out;
  }

  // returns a serie in the jqplot format
  // Move on the server side
  var build_user_value_chart_serie = function(user_value) {
    var out;
    // no interpolations or mid points, just draw a straight line
    if(input_element.command_type == 'value') {
      var start_value = get_slider().get('start_value');
      out = [
        [scenario.start_year,start_value],
        [scenario.end_year, user_value]
      ];
    } else if(input_element.command_type == 'growth_rate') {
      // draw a nice curve
      out = [[scenario.start_year, 100]];
      for(i = 1; scenario.start_year + i <= scenario.end_year; i++) {
        out.push([scenario.start_year + i, calculate_value(user_value, i)]);
      }
    } else if(input_element.command_type == 'efficiency_improvement') {
      // as above, inverted
      out = [[scenario.start_year, 100]];
      for(i = 1; scenario.start_year + i <= scenario.end_year; i++) {
        out.push([scenario.start_year + i, calculate_value(user_value, -i)]);
      }
    }
    return out;
  }
  
  // shows the bar with the scenario end year
  var add_reference_bar = function() {
    if(scenario.end_year == 2050) { return; }
        
    // get the series values. It's a doubly nested array
    var values = _.flatten(_.map(chart_data.series, function(x) {
      return _.map(x, function(y) { return y[1]; });
    }));
    
    chart_data.series.push([[scenario.end_year, 0],[scenario.end_year, _.max(values)]]);
    chart_data.series_options.push({ lineWidth: 3, color: "#FFA013", markerOptions: { show: false}});
  }
  
  var slider_is_available = function() {
    return parent && parent.input_elements
  }
  
  var set_slider_value = function(x) {
    if(!slider_is_available()) { return false; }
    return get_slider().set({ user_value : x });
  }
  
  var update_input_element = function() {
    if(input_element.value_for_prediction !== false) {
      set_slider_value(input_element.value_for_prediction);
    }
  }
  
  // returns the related input element
  var get_slider = function() {
    if(!slider_is_available()) { return false; }
    return parent.input_elements.get(input_element.id);
  }
  
  var plot_chart = function() {
    // let's get the current slider value
    if (scenario.available){
      if (slider_is_available()) {
        var user_value = get_slider().get('user_value');
        var user_serie = build_user_value_chart_serie(user_value);
        chart_data.series.unshift(user_serie);
        var unit = get_slider().get('unit')
        $('#user_value').prepend(user_value+unit);
      }
    }

    add_reference_bar();

    // Let's plot the chart
    $.jqplot("backcasting", chart_data.series, {
        grid: {
          background: '#ffffff',
          borderWidth: 0,
          borderColor: '#ffffff',
          shadow: false
        },
        axes:{
          xaxis:{tickOptions:{formatString:'%.0f',showGridline: false},numberTicks:5},
          yaxis:{tickOptions:{formatString:'%.0f'},numberTicks:5, min: 0}
        },
        seriesColors: chart_data.colours,
        series: chart_data.series_options,
        seriesDefaults : {
          markerOptions: { show: false },
          yaxis:'y2axis'
        }
      }
    );
  }

  // bootstrap
  $(document).ready(function(){
    plot_chart();
  });

  
  // interface stuff
  
  // ajax loading of prediction details
  $(".clickable_prediction").click(function(){
    
    var prediction_id = $(this).attr("prediction_id");
    input_element.value_for_prediction = $(this).data('slider_value');
    // if the user selects his own prediction
    if(prediction_id == undefined) {
      $(".prediction_details").empty();
      input_element.value_for_prediction = false;
      return;
    }    
    var url = "/predictions/" + prediction_id;
    if (slider_is_available()) {
       url = url + "?end_year="+scenario.end_year;
    };
    
    $(".prediction_details").busyBox({spinner: '<img src="/images/layout/ajax-loader.gif" />'});
    $(".prediction_details").load(url, function() {
      $(".prediction_details").busyBox('close');
    });
    $(".clickable_prediction").removeClass('active')
    $(this).addClass('active')
  });

  // extra info links
  $(".measure").live('click', function(event){
    event.preventDefault();
    $(this).find(".inline_description").toggle();
    $(this).toggleClass('active');
  });
  
  // apply prediction
  $("input.apply_prediction").live('click', function(){
    update_input_element();
    parent.$.fancybox.close();
  });
  
  // share prediction
  $("input.share_prediction").live('click', function(){
    window.open(this.getAttribute('href'), '_blank')
  });
});