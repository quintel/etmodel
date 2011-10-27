
var PolicyBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();

    InitializePolicyBar(this.model.get("container"), 
      this.result_serie1(), 
      this.result_serie2(), 
      this.ticks(), 
      this.model.series.length, 
      this.parsed_unit(), 
      this.model.colors(), 
      this.model.labels());
  },

  result_serie1 : function() {
    return _.flatten(this.model.value_pairs());
  },

  result_serie2 : function() {
    return _.map(this.result_serie1(), function(r) {
      return 100 - r;
    });
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