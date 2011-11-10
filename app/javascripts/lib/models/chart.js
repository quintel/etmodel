
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
  
  title_node : function() {
    return $("#charts_holder h3");
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
      case 'horizontal_stacked_bar' :
        this.view = new HorizontalStackedBarChartView({model : this});
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
      case 'grouped_vertical_bar' :
        this.view = new GroupedVerticalBarChartView({model : this});
        break;
      case 'policy_bar' :
        this.view = new PolicyBarChartView({model : this});
        break;
      case 'line' :
        this.view = new LineChartView({model : this});
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
    this.title_node().html(this.get("name"));
    return this.view;
  },

  // @return [ApiResultArray] = [
  //   [[2010,0.4],[2040,0.6]],
  //   [[2010,20.4],2040,210.4]]
  // ]
  results : function(exclude_target) {
    var series, out;
    if (exclude_target == undefined || exclude_target == null){
      series =  this.series.toArray();
    }
    else{
      series =  this.non_target_series();
    }
    out = _(series).map(function(serie) {
      var res = serie.result(); 
      return res;
    });

    
    // policy goal charts show percentages but the gqueries return values
    // in the [0,1] range. Let's take care of that
    if (this.get('percentage')) {
      out = _(out).map(function(serie){
        var scaled = [
          [
            serie[0][0],
            serie[0][1] * 100
          ],
          [
            serie[1][0],
            serie[1][1] * 100
          ]
        ];
        return scaled;
      });
    }
    
    return out;
  },
  
  colors : function() {
    return this.series.map(function(serie) { return serie.get('color'); });
  },
  labels : function() {
    return this.series.map(function(serie) { return serie.get('label'); });
  },
  // @return [Float] Only values of the present
  values_present : function() {
    var exclude_target_series = true
    return _.map(this.results(exclude_target_series), function(result) { return result[0][1]; });
  },
  // @return [Float] Only values of the future
  values_future : function() {
    var exclude_target_series = true
    return _.map(this.results(exclude_target_series), function(result) { return result[1][1]; });
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
    return this.series.reject(function(serie) { return serie.get('is_target_line'); });
  },
  target_series : function() {
    return this.series.select(function(serie) { return serie.get('is_target_line'); });
  },
  // @return Array of present and future target
  target_results : function() {
    return _.flatten(_.map(this.target_series(), function(serie) { return serie.result()[1][1]; })); 
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

  load : function(chart_id) {
    if (this.current() == parseInt(chart_id)) {
      // if chart_id == currently shown chart, skip.
      return;
    }
    var url = '/output_elements/'+chart_id+'.js?'+timestamp();
    $.getScript(url, function() { 
      App.call_api('');
      // show/hide default chart button
      if(chart_id != charts.current_default_chart) {
        $("a.default_charts").show();
      } else {
        $("a.default_charts").hide();
      }
      // update chart information link
      $("#output_element_actions a.chart_info").attr("href", "/descriptions/charts/" + chart_id);
      // update the position of the output_element_actions
      $("#output_element_actions").removeClass();
      $("#output_element_actions").addClass(charts.first().get("type"));
    });
  },
  
  // returns the current chart id
  current : function() {
    return parseInt(this.first().get('id'));
  }
});
window.charts = new ChartList();
