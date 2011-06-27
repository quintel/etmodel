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
    var results = this.results_with_1990();
    var smallest_scale = 3
    
    var target_serie = this.model.target_series()[0]
    
    var result = target_serie.result()[1][1]; // target_series has only present or future value
    // result = Metric.scaled_value(result, 2, 3);

    var x = parseFloat(target_serie.get('position'));
    results.push([[x - 0.4, result], [x + 0.4, result]]);
    return results;
  },
  //custom function for showing 1990
  results_with_1990 : function(){
    var result = this.model.results();
    return [[result[0][1][1],result[1][0][1],result[1][1][1]]];
  },
  ticks : function() {
    // added 1990 in the code here, this is the only charts that uses this.
    return [1990,App.settings.get("start_year"), App.settings.get("end_year")];
  },
  filler : function() {
    // add this filler to create a dummy value. This is needed because the target line must be added to the end of the serie
    return [{}];
  },
  axis_scale : function(){
    return [0,this.axis_max_value( _.flatten(this.results()))];
  }
});


