var HtmlTableChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();
    this.model.container_node().html(window.table_content);
    this.fill_cells();
  },

  fill_cells : function() {
    console.log("Filling cells");
    this.dynamic_cells().each(function(){
      var gqid = $(this).data('gquery_id');
      var gquery = window.gqueries.with_key(gqid)[0];
      if(!gquery) return;
      var raw_value = gquery.result()[1][1];
      var value = Metric.round_number(raw_value, 1);
      $(this).html(value);
    });
  },

  // returns a jQuery collection of cells to be dynamically filled
  dynamic_cells : function() {
    return this.model.container_node().find("td");
  }
});
