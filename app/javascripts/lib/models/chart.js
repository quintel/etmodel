
var Chart = Backbone.Model.extend({
  defaults : {
    'container' : 'current_chart'
  },
  
  initialize : function() {
    this.series = (this.get('type') == 'block') ? new BlockChartSeries() : new ChartSeries();
    this.bind('change:type', this.render);
    this.render();
  },
  
  container_node : function() {
    return $("#" + this.get("container"));
  },
  
  render : function() {
    var type = this.get('type');
    switch (type) {
      case 'bezier' :
        this.view = new BezierChartView({model : this});
        break;
      case 'horizontal_bar' :
        this.view = new HorizontalBarChartView({model : this});
        break;
      case 'mekko' :
        this.view = new MekkoChartView({model : this});
        break;
      case 'waterfall' :
        this.view = new WaterfallChartView({model : this});
        break;
      case 'vertical_stacked_bar' :
        this.view = new VerticalStackedBarChartView({model : this});
        break;
      case 'policy_bar' :
        this.view = new PolicyBarChartView({model : this});
        break;
      case 'policy_line' :
        this.view = new PolicyLineChartView({model : this});
        break;
      case 'block' :
        this.view = new BlockChartView({model : this});
        break;
      case 'vertical_bar' :
        this.view = new VerticalBarChartView({model : this});
        break;
      case 'html_table' :
        this.view = new HtmlTableChartView({model : this});
        break;
      default:
        this.view = new HtmlTableChartView({model : this});
    }
    return this.view;
  },

  // @return [ApiResultArray] = [
  //   [[2010,0.4],[2040,0.6]],
  //   [[2010,20.4],2040,210.4]]
  // ]
  results : function() {
    return this.series.map(function(serie) { return serie.result(); });
  },
  colors : function() {
    return this.series.map(function(serie) { return serie.get('color'); });
  },
  labels : function() {
    return this.series.map(function(serie) { return serie.get('label'); });
  },
  // @return [Float] Only values of the present
  values_present : function() {
    return _.map(this.results(), function(result) { return result[0][1]; });
  },
  // @return [Float] Only values of the future
  values_future : function() {
    return _.map(this.results(), function(result) { return result[1][1]; });
  },
  // @return [Float] All possible values. Helpful to determine min/max values
  values : function() {
    return _.flatten([this.values_present(), this.values_future()]);
  },
  // @return [[Float,Float]] Array of present/future values [Float,Float]
  value_pairs : function() {
    return this.series.map(function(serie) { return serie.result_pairs(); });
  },
  non_target_series : function() {
    return this.series
      .reject(function(serie) { return serie.get('is_target'); });
  },
  target_series : function() {
    return this.series
      .select(function(serie) { return serie.get('is_target'); });
  },
  // @return Array of hashes {label, present_value, future_value}
  series_hash : function() {
    return this.series.map(function(serie) {
      var res = serie.result();
      var out = {
        label : serie.get('label'),
        present_value : res[0][1],
        future_value : res[1][1]
      };
      return out; 
    });
  }
});



var ChartList = Backbone.Collection.extend({
  model : Chart,

  initialize : function() {
    //_.bindAll(this, 'change_chart');
    //this.bind('add', this.change_chart);
  },

  change : function(chart) {
    var old_chart = this.first();
    if (old_chart !== undefined) {
      this.remove(old_chart);      
    }
    this.add(chart);
  },

  // this should be refactored into events. So we can trigger('loading') or 'loaded'
  show_loading : function() { $('#chart_loading').show(); },
  hide_loading : function() { $('#chart_loading').hide(); },

  load : function(chart_id) {
    if (this.first().get('id')+'' == chart_id + '') {
      // if chart_id == currently shown chart, skip.
      return;
    }
    window.charts.show_loading();
    var url = '/output_elements/'+chart_id+'.js?'+timestamp();
    $.getScript(url, function() { 
      window.charts.hide_loading();
      App.call_api('');
    });
  }
});
window.charts = new ChartList();
