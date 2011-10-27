
var GroupedVerticalBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();
    InitializeGroupedVerticalBar(
      this.model.get("container"),
      this.result_serie(),
      this.ticks(),
      this.model.series.length,
      this.parsed_unit(),
      this.model.colors(),
      this.model.labels());
  },

  result_serie : function() {
    return _.flatten(this.model.value_pairs());
  },


  ticks : function() {
    var ticks = [];
    this.model.series.each(function(serie) {
      ticks.push(serie.result()[0][0]);
      ticks.push(serie.result()[1][0]);
    });
    return ticks;
  }
});