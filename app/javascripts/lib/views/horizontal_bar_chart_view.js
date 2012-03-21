/* DO NOT MODIFY. This file was compiled Wed, 21 Mar 2012 15:01:41 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/horizontal_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.HorizontalBarChartView = (function(_super) {

    __extends(HorizontalBarChartView, _super);

    function HorizontalBarChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_chart = __bind(this.render_chart, this);
      this.render = __bind(this.render, this);
      HorizontalBarChartView.__super__.constructor.apply(this, arguments);
    }

    HorizontalBarChartView.prototype.cached_results = null;

    HorizontalBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    HorizontalBarChartView.prototype.render = function() {
      this.clear_results_cache();
      this.clear_container();
      return this.render_chart();
    };

    HorizontalBarChartView.prototype.results = function() {
      var i, model_results, out, scale, scaled, value, _ref;
      if (this.cached_results) return this.cached_results;
      model_results = this.model.results();
      scale = this.data_scale();
      out = [];
      for (i = 0, _ref = model_results.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        value = model_results[i][0][1];
        scaled = Metric.scale_value(value, scale);
        out.push([scaled, parseInt(i) + 1]);
      }
      this.cached_results = out;
      return [out];
    };

    HorizontalBarChartView.prototype.clear_results_cache = function() {
      return this.cached_results = null;
    };

    HorizontalBarChartView.prototype.render_chart = function() {
      return $.jqplot(this.container_id(), this.results(), this.chart_opts());
    };

    HorizontalBarChartView.prototype.chart_opts = function() {
      var out;
      out = {
        seriesColors: this.model.colors(),
        highlighter: this.defaults.highlighter,
        grid: this.defaults.grid,
        seriesDefaults: {
          renderer: $.jqplot.BarRenderer,
          pointLabels: {
            show: true
          },
          rendererOptions: {
            barDirection: 'horizontal',
            varyBarColor: true,
            barPadding: 6,
            barMargin: 100,
            shadow: this.defaults.shadow
          }
        },
        axes: {
          yaxis: {
            renderer: $.jqplot.CategoryAxisRenderer,
            ticks: this.model.labels()
          },
          xaxis: {
            rendererOptions: {
              forceTickAt0: true
            },
            numberTicks: 6,
            tickOptions: {
              formatString: "%.1f" + (this.parsed_unit())
            }
          }
        }
      };
      return out;
    };

    return HorizontalBarChartView;

  })(BaseChartView);

}).call(this);
