
var VerticalBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    this.clear_container();
    
    InitializeVerticalBar(this.model.get("container"), 
      this.results(), 
      this.ticks(),
      this.filler(),
      this.model.get('show_point_label'),
      this.parsed_unit(), // this.parsed_unit(smallest_scale)
      this.axis_scale(),
      this.model.colors(),
      this.model.labels());
  },

  results : function() {
    return [[1,2,3]];
  },

  ticks : function() {
    return ['2010', '2040'];
  },
  filler : function() {
    return [];
  },
  parsed_unit : function() {
    return 'PJ';
  },
  axis_scale : function() {
    return [0,10];
  }
});