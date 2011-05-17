
var HorizontalBarChartView = BaseChartView.extend({
  cached_results : null,
  
  initialize : function() {
    this.initialize_defaults();
  },
  
  render : function() {
    this.clear_results_cache();
    // SEB: maybe needs a better way to remove jqplot objects.
    //      => possible js memory leak
    this.clear_container();
      InitializeHorizontalBar(
        this.model.get("container"),
        this.results(),
        true,
        'PJ',
        this.axis_scale(),
        this.model.colors(),
        this.model.labels()
      );
  },
  
  // the horizontal graph expects data in this format:
  // [value, 1], [value, 2], ...
  // TODO: refactoring - PZ Tue 3 May 2011 17:44:14 CEST
  results : function() {
    if (this.cached_results) return this.cached_results;
    var model_results = this.model.results();    
    var out = []
    for(i = 0; i < model_results.length; i++) {
      out.push([model_results[i][0][1], parseInt(i)+1]);
    }
    this.cached_results = out;
    return out;
  },
  
  clear_results_cache : function() {
    this.cached_results = null;
  },
  
  axis_scale : function() {
    var values = _.map(this.results(), function(i){ return i[0]});
    var max = _.max(values);
    return [0, max * 1.1];
  }
});

