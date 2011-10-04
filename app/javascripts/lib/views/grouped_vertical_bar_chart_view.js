
var GroupedVerticalBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();

    InitializeGroupedVerticalBar(this.model.get("container"),
      this.result_serie(),
      this.ticks(),
      this.model.series.length,
      this.parsed_unit(),
      this.axis_scale(),
      this.model.colors(),
      this.model.labels());
  },

  result_serie : function() {
    return _.flatten(this.model.value_pairs());
  },


  ticks : function() {
    var ticks = [];
    this.model.series.each(function(serie) {
      // RD: when updating jqplot to version 720+ the ticks should not be in an array!
      ticks.push([ serie.result()[0][0] ]);
      ticks.push([ serie.result()[1][0] ]);
    });
    return ticks;
  }
});