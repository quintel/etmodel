/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/horizontal_stacked_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.HorizontalStackedBarChartView = (function(_super) {

    __extends(HorizontalStackedBarChartView, _super);

    function HorizontalStackedBarChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_chart = __bind(this.render_chart, this);
      this.render = __bind(this.render, this);
      HorizontalStackedBarChartView.__super__.constructor.apply(this, arguments);
    }

    HorizontalStackedBarChartView.prototype.cached_results = null;

    HorizontalStackedBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    HorizontalStackedBarChartView.prototype.render = function() {
      this.clear_results_cache();
      this.clear_container();
      return this.render_chart();
    };

    HorizontalStackedBarChartView.prototype.results = function() {
      var series;
      series = {};
      this.model.series.each(function(serie) {
        var group;
        group = serie.get('group');
        if (group) {
          if (!series[group]) series[group] = [];
          return series[group].push([serie.result_pairs()[0], series[group].length + 1]);
        }
      });
      return _.map(series, function(values, group) {
        return values;
      });
    };

    HorizontalStackedBarChartView.prototype.clear_results_cache = function() {
      return this.cached_results = null;
    };

    HorizontalStackedBarChartView.prototype.axis_scale = function() {
      var max, min;
      min = this.model.get('min_axis_value');
      max = this.model.get('max_axis_value');
      return [min, max];
    };

    HorizontalStackedBarChartView.prototype.ticks = function() {
      var groups;
      groups = this.model.series.map(function(serie) {
        return serie.get('group_translated');
      });
      return _.uniq(groups);
    };

    HorizontalStackedBarChartView.prototype.colors = function() {
      return _.uniq(this.model.colors());
    };

    HorizontalStackedBarChartView.prototype.labels = function() {
      return _.uniq(this.model.labels());
    };

    HorizontalStackedBarChartView.prototype.render_chart = function() {
      return $.jqplot(this.container_id(), this.results(), this.chart_opts());
    };

    HorizontalStackedBarChartView.prototype.can_be_shown_as_table = function() {
      return false;
    };

    HorizontalStackedBarChartView.prototype.chart_opts = function() {
      var out;
      out = {
        stackSeries: true,
        highlighter: this.defaults.highlighter,
        seriesColors: this.colors(),
        grid: this.defaults.grid,
        legend: this.create_legend({
          num_columns: 6,
          labels: this.ticks()
        }),
        seriesDefaults: {
          renderer: $.jqplot.BarRenderer,
          pointLabels: {
            show: this.model.get('show_point_label')
          },
          rendererOptions: {
            barDirection: 'horizontal',
            varyBarColor: true,
            barPadding: 8,
            barMargin: 30,
            shadow: this.defaults.shadow
          }
        },
        axes: {
          yaxis: {
            renderer: $.jqplot.CategoryAxisRenderer,
            ticks: this.labels()
          },
          xaxis: {
            min: this.axis_scale()[0],
            max: this.axis_scale()[1],
            numberTicks: 5,
            tickOptions: {
              formatString: "%.2f" + (this.model.get('unit')),
              fontSize: '10px'
            }
          }
        }
      };
      return out;
    };

    return HorizontalStackedBarChartView;

  })(BaseChartView);

}).call(this);
