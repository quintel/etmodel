/* DO NOT MODIFY. This file was compiled Tue, 06 Mar 2012 12:33:47 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/bezier_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BezierChartView = (function(_super) {

    __extends(BezierChartView, _super);

    function BezierChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_chart = __bind(this.render_chart, this);
      this.render = __bind(this.render, this);
      BezierChartView.__super__.constructor.apply(this, arguments);
    }

    BezierChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    BezierChartView.prototype.render = function() {
      this.clear_container();
      return this.render_chart();
    };

    BezierChartView.prototype.scaled_results = function() {
      var scale;
      scale = this.data_scale();
      return _.map(this.model.results(), function(gquery) {
        return _.map(gquery, function(pair) {
          return [pair[0], Metric.scale_value(pair[1], scale)];
        });
      });
    };

    BezierChartView.prototype.formatted_results = function() {
      return this.plot_series(this.scaled_results(), App.settings.get('start_year'), App.settings.get('end_year'), this.model.get('growth_chart'));
    };

    BezierChartView.prototype.render_chart = function() {
      return $.jqplot(this.container_id(), this.formatted_results(), this.chart_opts());
    };

    BezierChartView.prototype.chart_opts = function() {
      return {
        grid: this.defaults.grid,
        legend: this.create_legend({
          num_columns: 2
        }),
        stackSeries: false,
        seriesDefaults: {
          renderer: $.jqplot.BezierCurveRenderer,
          pointLabels: {
            show: false
          },
          yaxis: 'y2axis'
        },
        seriesColors: this.model.colors(),
        axesDefaults: this.defaults.stacked_line_axis_default,
        axes: {
          xaxis: {
            numberTicks: 2,
            tickOptions: {
              showGridline: false
            },
            ticks: [App.settings.get('start_year'), App.settings.get('end_year')]
          },
          y2axis: {
            rendererOptions: {
              forceTickAt0: true
            },
            borderColor: '#CCCCCC',
            tickOptions: {
              formatString: "%.0f" + (this.parsed_unit())
            }
          }
        }
      };
    };

    BezierChartView.prototype.plot_series = function(series, start_x, end_x, growth) {
      var end_value, end_y, result, serie, start_value, start_y, _i, _len;
      result = [];
      start_value = 0;
      end_value = 0;
      for (_i = 0, _len = series.length; _i < _len; _i++) {
        serie = series[_i];
        start_y = serie[0][1];
        start_value += start_y;
        end_y = serie[1][1];
        end_value += end_y;
        if (growth) {
          if (start_value > end_value) {
            result.push([[start_x, start_value], this.set_decrease_ex_curve(start_x, end_x, start_value, end_value).concat([end_x, end_value])]);
          } else {
            result.push([[start_x, start_value], this.set_growth_ex_curve(start_x, end_x, start_value, end_value).concat([end_x, end_value])]);
          }
        } else {
          result.push([[start_x, start_value], this.set_s_curve(start_x, end_x, start_value, end_value).concat([end_x, end_value])]);
        }
      }
      return result;
    };

    BezierChartView.prototype.set_s_curve = function(start_x, end_x, start_y, end_y) {
      var end_handle_x, end_handle_y, start_handle_x, start_handle_y;
      start_handle_x = start_x + ((end_x - start_x) / 2);
      start_handle_y = start_y;
      end_handle_x = end_x - ((end_x - start_x) / 4);
      end_handle_y = end_y;
      return [start_handle_x, start_handle_y, end_handle_x, end_handle_y];
    };

    BezierChartView.prototype.set_growth_ex_curve = function(start_x, end_x, start_y, end_y) {
      var end_handle_x, end_handle_y, start_handle_x, start_handle_y;
      start_handle_x = start_x + ((end_x - start_x) / 2);
      start_handle_y = start_y;
      end_handle_x = end_x;
      end_handle_y = end_y;
      return [start_handle_x, start_handle_y, end_handle_x, end_handle_y];
    };

    BezierChartView.prototype.set_decrease_ex_curve = function(start_x, end_x, start_y, end_y) {
      var end_handle_x, end_handle_y, start_handle_x, start_handle_y;
      start_handle_x = start_x + ((end_x - start_x) / 2);
      start_handle_y = end_y;
      end_handle_x = end_x;
      end_handle_y = end_y;
      return [start_handle_x, start_handle_y, end_handle_x, end_handle_y];
    };

    return BezierChartView;

  })(BaseChartView);

}).call(this);
