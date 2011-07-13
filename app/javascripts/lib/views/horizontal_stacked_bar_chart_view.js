
var HorizontalStackedBarChartView = BaseChartView.extend({
  cached_results : null,
  
  initialize : function() {
    console.info("loading")
    this.initialize_defaults();
  },
  
  render : function() {
    this.clear_results_cache();
    this.clear_container();
      InitializeHorizontalStackedBar(
        this.model.get("container"),
        this.results(),
        this.ticks(),
        false,
        "KG/GJ",
        this.axis_scale(),
        this.colors(),
        [ "Coal" ,"Oil" ,"Gas","Uranium" ]
      );
  },
  
  // the horizontal stacked graph expects data in this format:
  // [[value1, 1], [value1, 2]],[[value2, 1], [value2, 2]] ...
  results : function() {
      var series = {};
      this.model.series.each(function(serie) {
        var group = serie.get('group');
        if (group) {
          if (!series[group]) { series[group] = []; }
          series[group].push([serie.result_pairs()[0],(series[group].length + 1)]);
        }
      });
      out = _.map(series, function(values, group) {return values})

     return out;
  },
  
  clear_results_cache : function() {
    this.cached_results = null;
  },
  
  axis_scale : function() {
    var min = this.model.get('min_axis_value')
    if (min == undefined)  console.info('minimal axis value not defined');
    var max = this.model.get('max_axis_value')
    if (max == undefined)  console.info('maximal axis value not defined');
    return [min, max];
  },
    
  ticks : function() {
    var groups = this.model.series.map(function(serie) {return serie.get('group')});
    return _.uniq(groups);
  },
  colors : function() {
    return _.uniq(this.model.colors());
  },
  
  
});

