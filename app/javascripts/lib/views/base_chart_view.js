


var BaseChartView = Backbone.View.extend({
  initialize_defaults : function() {
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
  },
  
  // SEB: maybe needs a better way to remove jqplot objects.
  //      => possible js memory leak  
  clear_container : function() {
    this.model.container_node().empty();
  },

  max_value : function() {
    var max_value = _.max($.merge([
      _.reduce(values_present, function(sum, v) { return sum + (v > 0 ? v : 0); }, 0),
      _.reduce(values_future, function(sum, v) { return sum + (v > 0 ? v : 0); }, 0),
      this.model.target_results()
    ]))
  },

  parsed_unit : function() {
    var unit = this.model.get('unit');
    return Metric.parsed_unit(this.max_value, unit);
  }
});
