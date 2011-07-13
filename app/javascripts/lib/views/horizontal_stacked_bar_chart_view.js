
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
        ["#4169E1", "#FFA500", "#228B22", "#FF0000"],
        [ "Coal" ,"Oil" ,"Gas","Uranium" ]
      );
  },
  
  // the horizontal graph expects data in this format:
  // [value, 1], [value, 2], ...
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
    // var values = _.map(this.results(), function(i){ return i[0]});
    // var max = _.max(values);
    // if (max == 0) { max = 3 };
    return [0, 100 * 1.1];
  },
    
  ticks : function() {
    ["a","b","c","d"];
  }
});

