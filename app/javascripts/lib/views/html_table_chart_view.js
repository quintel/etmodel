var HtmlTableChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();
    this.model.container_node().html(window.table_content);
  }
});
