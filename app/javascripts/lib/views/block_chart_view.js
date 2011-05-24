
var BlockChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    update_block_charts(this.model.series.map(function(serie) { return serie.result() }));
  }
});