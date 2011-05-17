
var BezierChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();
    InitializeBezier(this.model.get("container"), 
      this.model.results(), 
      true, 
      this.parsed_unit(), 
      this.axis_scale(), 
      this.model.colors(), 
      this.model.labels());
  }
});