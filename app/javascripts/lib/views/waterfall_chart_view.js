

var WaterfallChartView = BaseChartView.extend({
  initialize : function() {
    this.initialize_defaults();
    this.HEIGHT = '460px';
  },

  render : function() {
    this.clear_container();
    InitializeWaterfall(this.model.get("container"), 
      this.results(), 
      this.model.get('unit'), 
      this.axis_scale_adjusted_with_ticks(), 
      this.colors(), 
      this.labels(),
      this.number_of_ticks());
  },

  colors : function() {
    var colors = this.model.colors();
    colors.push(colors[0]);
    return colors;
  },

  labels : function() {
    var labels = this.model.labels();
    labels.push(this.model.get('id') == 51 ? App.settings.get("end_year") : 'Total');
    return labels;
  },

  results : function() {
    var series = this.model.series.map(function(serie) { 
      var present = serie.result_pairs()[0]; 
      var future = serie.result_pairs()[1]; 
      if (serie.get('group') == 'value') {
        return present; // Take only the present value, as group == value queries only future/present 
      } else {
        return future - present;
      }
    });


    var start_scale = (this.model.get('id') == 61) ? 2 : 3;
    
    var scale_sum = Metric.scaled_scale(_.reduce(series, function(sum,n) {return sum + n;}, 0), start_scale);
    var scale_max = Metric.scaled_scale(_.max(series), start_scale);
    // fix the scaling when really small and large numbers are present
    var scale = (scale_sum > scale_max) ? scale_sum : scale_max;
    var series_scaled = _.map(series, function(value) {
      return Metric.scaled_value(value, start_scale, scale);
    });

    return series;
  },

  axis_scale_adjusted_with_ticks : function() {
    var axis_scale = this.axis_scale();
    var ticks = this.ticks();
    var ticks_negative = ticks[0];
    var ticks_positive = ticks[1];
    var tick_size = this.tick_size();

    axis_scale[0] = ticks_negative * tick_size * -1;
    axis_scale[1] = ticks_positive * tick_size;

    return axis_scale;
  },

  ticks : function() {
    var axis_scale = this.axis_scale();
    var min_value = Math.abs(axis_scale[0]);
    var max_value = Math.abs(axis_scale[1]);
    
    var tick_size = this.tick_size();
    var ticks_negative = min_value == 0 ? 0 : (min_value / tick_size);
    var ticks_positive = max_value == 0 ? 0 : (max_value / tick_size);

    if (ticks_positive + ticks_negative > 10) {
      ticks_negative = ticks_negative / 2;
      ticks_positive = ticks_positive / 2;
      tick_size = tick_size / 2;
    }
    return [ticks_negative, ticks_positive];
  },

  tick_size : function() {
    var axis_scale = this.axis_scale();
    var min_value = Math.abs(axis_scale[0]);
    var max_value = Math.abs(axis_scale[1]);
    
    var tick_size = this.calculate_tick_size(_.max([min_value, max_value]));
    return tick_size;     
  },

  number_of_ticks : function() {
    var ticks = this.ticks();
    var ticks_negative = ticks[0];
    var ticks_positive = ticks[1];

    var total_ticks = ticks_positive + ticks_negative + 1
    return [total_ticks, this.tick_size()];
  },


  calculate_tick_size : function(value) {
    var length = parseInt(Math.log(value) / Math.log(10));
    var divider = Math.pow(10,length);
    var ticks = value / divider;
    if (ticks < 2) { ticks = ticks * 5; }
    return value / ticks;
  }
  
});
