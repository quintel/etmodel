var BaseChartView = Backbone.View.extend({
  initialize_defaults : function() {
    _.bindAll(this, 'render', 'max_value', 'data_scale');
    this.model.bind('change', this.render);
  },
  
  clear_container : function() {
    this.model.container_node().empty();
  },

  max_value : function() {
    var sum_present = _.reduce(this.model.values_present(), function(sum, v) { return sum + (v > 0 ? v : 0); });
    var sum_future = _.reduce(this.model.values_future(), function(sum, v) { return sum + (v > 0 ? v : 0); });
    var target_results = _.flatten(this.model.target_results());
    var max_value = _.max($.merge([sum_present, sum_future], target_results));
    return max_value;
  },

  parsed_unit : function() {
    var unit = this.model.get('unit');
    return Metric.scale_unit(this.max_value(), unit);
  },
  
  data_scale: function() {
    return Metric.power_of_thousand(this.max_value());
  }
});
