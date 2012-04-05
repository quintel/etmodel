/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/vertical_stacked_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.VerticalStackedBarChartView = (function(_super) {

    __extends(VerticalStackedBarChartView, _super);

    function VerticalStackedBarChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_chart = __bind(this.render_chart, this);
      this.render = __bind(this.render, this);
      VerticalStackedBarChartView.__super__.constructor.apply(this, arguments);
    }

    VerticalStackedBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    VerticalStackedBarChartView.prototype.render = function() {
      this.clear_container();
      return this.render_chart();
    };

    VerticalStackedBarChartView.prototype.results = function() {
      var result, results, scale, serie, x, _i, _len, _ref;
      results = this.results_without_targets();
      scale = this.data_scale();
      if (!this.model.get('percentage')) {
        results = _.map(results, function(x) {
          return _.map(x, function(value) {
            return Metric.scale_value(value, scale);
          });
        });
      }
      _ref = this.model.target_series();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        serie = _ref[_i];
        result = serie.result()[0][1];
        result = Metric.scale_value(result, scale);
        x = parseFloat(serie.get('target_line_position'));
        results.push([[x - 0.4, result], [x + 0.4, result]]);
      }
      return results;
    };

    VerticalStackedBarChartView.prototype.results_without_targets = function() {
      return _.map(this.model.non_target_series(), function(serie) {
        return serie.result_pairs();
      });
    };

    VerticalStackedBarChartView.prototype.filler = function() {
      return _.map(this.model.non_target_series(), function(serie) {
        return {};
      });
    };

    VerticalStackedBarChartView.prototype.ticks = function() {
      return [App.settings.get("start_year"), App.settings.get("end_year")];
    };

    VerticalStackedBarChartView.prototype.render_chart = function() {
      return $.jqplot(this.container_id(), this.results(), this.chart_opts());
    };

    VerticalStackedBarChartView.prototype.chart_opts = function() {
      return {
        grid: this.defaults.grid,
        highlighter: this.defaults.highlighter,
        legend: this.create_legend({
          num_columns: 3
        }),
        stackSeries: true,
        seriesColors: this.model.colors(),
        seriesDefaults: {
          shadow: this.defaults.shadow,
          renderer: $.jqplot.BarRenderer,
          rendererOptions: {
            barPadding: 0,
            barMargin: 110,
            barWidth: 80
          },
          pointLabels: {
            show: this.model.get('show_point_label'),
            stackedValue: true,
            formatString: '%.1f',
            edgeTolerance: -50,
            ypadding: 0
          },
          yaxis: 'y2axis'
        },
        series: this.apply_target_line_serie_settings(this.filler()),
        axes: {
          xaxis: {
            renderer: $.jqplot.CategoryAxisRenderer,
            ticks: this.ticks(),
            tickOptions: {
              showMark: false,
              showGridline: false
            }
          },
          y2axis: {
            borderColor: '#cccccc',
            rendererOptions: {
              forceTickAt0: true
            },
            tickOptions: {
              formatString: "%." + (this.significant_digits()) + "f&nbsp;" + (this.parsed_unit())
            }
          }
        }
      };
    };

    VerticalStackedBarChartView.prototype.apply_target_line_serie_settings = function(serie_settings_filler) {
      var target_serie_settings;
      if (serie_settings_filler.length > 0) {
        target_serie_settings = [
          {
            renderer: $.jqplot.LineRenderer,
            disableStack: true,
            lineWidth: 1.5,
            shadow: true,
            showMarker: false,
            showLabel: true
          }, {
            renderer: $.jqplot.LineRenderer,
            disableStack: true,
            lineWidth: 1.5,
            shadow: true,
            showMarker: false,
            showLabel: false
          }
        ];
        return serie_settings_filler.concat(target_serie_settings);
      } else {
        return [];
      }
    };

    return VerticalStackedBarChartView;

  })(BaseChartView);

}).call(this);
