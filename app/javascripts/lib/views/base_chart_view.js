


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

  // was axis_values
  axis_scale : function() {
    var values_present = this.model.values_present();
    var values_future = this.model.values_future();

    if (this.model.get('percentage')) {
      return [0, 100];
    } 
    var axis_total_values = [
      _.reduce(values_present, function(sum, v) { return sum + (v > 0 ? v : 0); }, 0),
      _.reduce(values_future, function(sum, v) { return sum + (v > 0 ? v : 0); }, 0)
    ];
    
    return [0,this.axis_max_value(axis_total_values)];
  },

  // was axis_scale in ruby.
  // The axis value with which the chart should render.
  // It is basically the highest number + a bit of empty space.
  //
  axis_max_value : function(values) {
    var empty_space = 1.1;
    var total = _.max(values) * empty_space;
    var length = parseInt(Math.log(total) / Math.log(10), 10);
    var tick_size = Math.pow(10, length) ;
    var ratio = (total / 5) / tick_size;

    var result;

    if (ratio < 0.025) {
      result = tick_size * 0.05;
    } else if (ratio < 0.1) {
      result = tick_size * 0.1;
    } else if (ratio < 0.5) {
      result = tick_size * 0.5;
    } else if (ratio < 1) {
      result = tick_size;
    } else if (ratio < 1.5) {
      result = tick_size * 1.5;
    } else if (ratio < 2) {
      result = tick_size * 2;
    } else {
      result
    }

    return result * 5;
  },

  parsed_unit : function() {
    var unit = this.model.get('unit');
    var min_value = _.min(this.model.values());
    var max_value = this.axis_max_value(this.model.values());
    var start_scale; 

    if (this.model.get('unit') == "MT") {
      start_scale = 2;
    } else {
      start_scale = 3;
    }

    var scale = Metric.scaled_scale(max_value, start_scale);

    if (unit == 'PJ') {
      return Metric.scaling_in_words(scale, 'joules');
    } else if (unit == 'MT') {
      return Metric.scaling_in_words(scale, 'ton');
    } else if (unit == 'EUR') {
      return Metric.scaling_in_words(scale, 'currency');
    } else {
      return Metric.scaling_in_words(scale, unit);
    }
  }
});
