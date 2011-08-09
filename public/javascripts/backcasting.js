$(function(){
  var calculate_value = function(x, years) {
    var base = 1 + x / 100.0;
    var out = Math.pow(base, years) * 100;
    return out;
  }

  var get_mid_year = function() {
    return Math.floor(scenario.end_year - scenario.start_year) / 2 + scenario.start_year;
  }

  // returns a serie in the jqplot format
  var build_user_value_chart_serie = function(user_value) {
    var out;
    if(!input_element.growth) {
      out = [
        [scenario.start_year,0],
        [scenario.end_year, user_value]
      ];
    } else {
      out = [
        [scenario.start_year, 100],
        [get_mid_year(),      calculate_value(user_value, scenario.end_year - get_mid_year())],
        [scenario.end_year,   calculate_value(user_value, scenario.end_year - scenario.start_year)]
      ];
    }
    return out;
  }
  
  // shows the grey bar with the scenario end year
  var add_reference_bar = function() {
    if(scenario.end_year == 2050) { return; }
        
    // get the series values. It's a doubly nested array
    var values = _.flatten(_.map(chart_data.series, function(x) {
      return _.map(x, function(y) { return y[1]; });
    }));
    
    chart_data.series.push([[scenario.end_year, _.min(values)],[scenario.end_year, _.max(values)]]);
    chart_data.series_options.push({ lineWidth: 1, color: "777777", markerOptions: { show: false}});
  }

  // let's get the current slider value
  if (parent && parent.input_elements) {
    var user_value = parent.input_elements.get(input_element.id).get('user_value');
    var user_serie = build_user_value_chart_serie(user_value);
    chart_data.series.push(user_serie);
    chart_data.series_options.push({ lineWidth: 2, markerOptions: { show: false}});
    $("tr.user_prediction").show();
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
        xaxis:{tickOptions:{formatString:'%.0f'}},
        yaxis:{tickOptions:{formatString:'%.0f'}}
      },
      seriesColors: chart_data.colours,
      series: chart_data.series_options,
      seriesDefaults : {
        markerOptions: { show: false }
      }
    }
  );
  
  // interface stuff
  
  // ajax loading of prediction details
  $("input[type=radio]").click(function(){
    var prediction_id = $(this).val();
    // if the user selects his own prediction
    if(prediction_id == '') {
      $(".prediction_details").empty();
      return;
    }    
    var url = "/predictions/" + prediction_id;
    $(".prediction_details").busyBox({spinner: '<img src="/images/layout/ajax-loader.gif" />'});
    $(".prediction_details").load(url, function() {
      $(".prediction_details").busyBox('close');
    });
  });

  // extra info links
  $(".more_info a").live('click', function(event){
    event.preventDefault();
    $(this).parent().find(".inline_description").toggle();
  });
});