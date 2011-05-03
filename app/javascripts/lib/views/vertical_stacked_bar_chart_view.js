
var VerticalStackedBarChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },

  render : function() {
    // SEB: maybe needs a better way to remove jqplot objects.
    //      => possible js memory leak
    $('#current_chart').empty().css('height', this.HEIGHT);


    InitializeVerticalStackedBar("current_chart", 
      this.results(), 
      this.ticks(),
      this.filler(),
      this.get('show_point_label') ,
      this.parsed_unit(), // this.parsed_unit(smallest_scale)
      this.axis_scale(),
      this.model.colors(),
      this.model.labels());
  },

  results : function() {
    return [];
    var results = this.results_without_targets();
    var smallest_scale = null; 

    if (!this.model.get('percentage')) {
      var smallest_value = _.min(this.model.values);
      smallest_scale = Metric.scaled_scale(smallest_value, 3);

      results = results.map(function(x) {
        return x.map(function(value) {
          return Metric.scaled_value(value, 3, smallest_scale);
        });
      });
    }

    this.model.target_series().each(function(serie) {
      var result = serie.result()[0]; // target_series has only present or future value
      if (smallest_scale)
        result = Metric.scaled_value(result[0], 3, smallest_scale)
      var x = serie.get('position');
      results.push([[x - 0.4, result], [x + 0.4, result]]);
    });
    return results;
  },

  results_without_targets : function() {
    return this.model.non_target_series()
      .map(function(serie) { return serie.result_pairs(); });
  },
  filler : function() {
    return this.model.non_target_series()
      .map(function(s) { return {}; });
  },
  ticks : function() {
    return ['2010', '2040'];
  },
  axis_scale : function() {
    
  }
});