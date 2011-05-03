// user tracking
//
var tracking = {
  track: function(action, value) {
    $.ajax({
      // TODO: Move to correct location
      url: "http://tracker.et-model.com/tracks/new",
      dataType: 'jsonp',
      data: { "track": { "user": tracking.user_name, "action": action, "value": value } }
    });
  },
  score: function(values) {
    $.ajax({
      // TODO: Move to correct location
      url: "http://tracker.et-model.com/scores/new",
      dataType: 'jsonp',
      data: { "score": { "user": tracking.user_name, "round": tracking.round, "values": values} }
    });
  }
  
}


// tracking callbacks
//
  var value_previous;
$(function(){
  // upper tab
  $("#header #nav .nav-holder li").click(function(){
    tracking.track("tab_update", $(this).attr("id"));
  });
  
  // slide 
  $('li.accordion_element a').click(function(){
    tracking.track("slide_update", $(this).html());
  });
  // side categories
  $("#sidebar li").click(function(){
    tracking.track("category_update", $(this).attr("id"));
  });
  
  $("body").bind("dashboardUpdate", function(){
    var out = {}
    $("#footer .constraint").each(function(i, item){
      var label = $.trim($(this).find(".header").text());
      var value = $.trim($(this).find("strong").text());
      out[label] = value;
    });
    var score = $("#constraint_8 strong").html();
    tracking.track("dashboard_update", JSON.stringify(out));
    tracking.track("score_update", score);
  });

  // sliders
  $(".slider-button").mousedown(function(){
    var container = $(this).parentsUntil(".slider-advanced");
    value_previous = parseFloat(container.find(".slider-input .value").html()).toFixed(2);
  });
  
  $(".slider-button").mouseup(function(){
    var container = $(this).parentsUntil(".slider-advanced");
    var name = container.find(".name .text").html();
    var value = parseFloat(container.find(".slider-input .value").html()).toFixed(2);
    if(value_previous == null){
      var previous_value = parseFloat(container.find(".slider-info-box .data .old_value").html()).toFixed(2);
    } else {
      var previous_value = value_previous;
    }
    
    var value_string = name + " : " + value + " (";
    var diff = (value - previous_value).toFixed(2);
    if(diff > 0){
      value_string += "+";
    }
    value_string += diff + ")";
    value_previous = null;  
    tracking.track("slider_update", value_string);
  });
});

