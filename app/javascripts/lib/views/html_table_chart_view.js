
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
    var results = this.model.series_hash();
    
    var table = $("<table>");
    _.each(results, function(i){
      var r = $("<tr>")
      r.html("<td>"+i.label+"</td><td>"+i.present_value+"</td><td>"+i.future_value+"</td>");
      r.appendTo(table);
    });
    
    $('#current_chart').append(table);
  }
  
});
