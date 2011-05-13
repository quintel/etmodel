
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
    
    var table     = $('<table class="dynamic_table">');
    var text      = [];
    var row_count = results.length;
    var ct        = 0;
    
    // way faster
    for (var i = 0; i < row_count; i++) {
      text[ct++] = "<tr><td>";
      text[ct++] = results[i].label;
      text[ct++] = "</td><td>";
      text[ct++] = results[i].present_value;
      text[ct++] = "</td><td>";
      text[ct++] = results[i].future_value;
      text[ct++] = "</td></tr>";
    }
    
    table.append(text.join(''));

    $('#current_chart').append(table);
  }
  
});
