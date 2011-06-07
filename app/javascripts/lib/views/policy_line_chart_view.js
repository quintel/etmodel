
var PolicyLineChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();
    InitializePolicyLine(this.model.get("container"), 
      this.model.results(), 
      this.model.get('unit'), 
      this.axis_scale(), 
      this.model.colors(), 
      this.model.labels());
  }
});