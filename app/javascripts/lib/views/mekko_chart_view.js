
var MekkoChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
  },
  
  render : function() {
    this.clear_container();

    InitializeMekko(this.model.get("container"), 
      this.results(), 
      this.parsed_unit(), 
      this.colors(), 
      this.labels(),
      this.group_labels());
  },


  results : function() {
    var start_scale = 3;
    var series = {};
    var values = [];

    // RD: push the serie results in the defined groups
    this.model.series.each(function(serie) {
      var group = serie.get('group');
      if (group) {
        if (!series[group]) { series[group] = []; }
        series[group].push(serie.result_pairs()[0]);
        values.push(serie.result_pairs()[0]);
      }
    });

    // RD: scale the values! (this should be refactored!)
    var smallest_scale = Metric.scaled_scale(_.sum(series), start_scale);
    var results = _.map(series, function(sector_values, sector) {
      return _.map(sector_values, function(value) {
        return Metric.scaled_value(value, start_scale, smallest_scale);
      })
    })
    return results;
  },

  colors : function() {
    return _.uniq(this.model.colors());
  },
  
  labels : function() {
    var labels = this.model.labels();
    // TODO: the old model also has percentage per group. was ommited to simplify things.
    return _.uniq(labels);
  },

  group_labels : function() {
    var group_labels = this.model.series.map(function(serie) {return serie.get('group_translated')});
    return _.uniq(group_labels);
  }
})