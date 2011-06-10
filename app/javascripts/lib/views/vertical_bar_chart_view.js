
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
      this.parsed_unit(),
      this.axis_scale(),
      this.model.colors(),
      this.model.labels());
  },

  results : function() {
    return [[1,2,3]];
  },

  ticks : function() {
    return [App.settings.get("start_year"), App.settings.get("end_year")];
  },
  filler : function() {
    return [];
  },
  axis_scale : function() {
    return [0,10];
  }
});