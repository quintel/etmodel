// This charttype is only used in the co2 dashbord
// It containt some custom additions to the series showing a historic value 
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
    var result = this.model.results();
    return [[result[0][1][1],result[1][0][1],result[1][1][1]]];
  },

  ticks : function() {
    return [1990,App.settings.get("start_year"), App.settings.get("end_year")];
  },
  filler : function() {
    return [];
  }
});