/* DO NOT MODIFY. This file was compiled Wed, 07 Mar 2012 08:31:37 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/scatter_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.ScatterChartView = (function(_super) {

    __extends(ScatterChartView, _super);

    function ScatterChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.y_axis_unit = __bind(this.y_axis_unit, this);
      this.x_axis_unit = __bind(this.x_axis_unit, this);
      this.render_chart = __bind(this.render_chart, this);
      this.results = __bind(this.results, this);
      this.render = __bind(this.render, this);
      ScatterChartView.__super__.constructor.apply(this, arguments);
    }

    ScatterChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    ScatterChartView.prototype.render = function() {
      this.clear_container();
      return this.render_chart();
    };

    ScatterChartView.prototype.results = function() {
      return this.model.series.map(function(serie) {
        return [serie.result()];
      });
    };

    ScatterChartView.prototype.render_chart = function() {
      return $.jqplot(this.container_id(), this.results(), this.chart_opts());
    };

    ScatterChartView.prototype.x_axis_unit = function() {
      return this.model.get('unit').split(';')[0];
    };

    ScatterChartView.prototype.y_axis_unit = function() {
      return this.model.get('unit').split(';')[1];
    };

    ScatterChartView.prototype.chart_opts = function() {
      var out;
      out = {
        seriesColors: this.model.colors(),
        grid: this.defaults.grid,
        legend: this.create_legend({
          num_columns: 1
        }),
        seriesDefaults: {
          lineWidth: 1.5,
          showMarker: true,
          yaxis: 'yaxis'
        },
        axes: {
          xaxis: {
            rendererOptions: {
              forceTickAt0: true
            },
            numberTicks: 5,
            tickOptions: {
              fontSize: this.defaults.font_size,
              showGridline: true,
              formatString: "%.1f&nbsp;" + (this.x_axis_unit())
            }
          },
          yaxis: {
            rendererOptions: {
              forceTickAt0: true
            },
            tickOptions: {
              formatString: "%.1f&nbsp;" + (this.y_axis_unit())
            }
          }
        }
      };
      return out;
    };

    return ScatterChartView;

  })(BaseChartView);

}).call(this);
