
var HtmlTableChartView = BaseChartView.extend({
  cached_results : null,
  
  initialize : function() {
    this.initialize_defaults();
  },
  
  render : function() {
    $('#current_chart').empty().css('height', this.HEIGHT);
    this.create_table(this.model);
  },
  
  // Horrible. PZ Mon 9 May 2011 14:38:37 CEST
  create_table : function(data) {
    var x = data.series;
    console.log(x);
    var out = [];
    
    x.each(function(i){
      out.push ({
        label : i.get("label"),
        present_value : i.get("gquery").get("present_value"),
        future_value : i.get("gquery").get("future_value")
      });
    })
    // $("#current_chart").html(JSON.stringify(out));
    
    var table = $("<table>");
    _.each(out, function(i){
      var r = $("<tr>")
      r.html("<td>"+i.label+"</td><td>"+i.present_value+"</td><td>"+i.future_value+"</td>");
      r.appendTo(table);
    });
    
    $('#current_chart').append(table);
  }
  
});
