/* DO NOT MODIFY. This file was compiled Wed, 21 Mar 2012 15:07:26 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/line_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.LineChartView = (function(_super) {

    __extends(LineChartView, _super);

    function LineChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_line_chart = __bind(this.render_line_chart, this);
      this.render = __bind(this.render, this);
      LineChartView.__super__.constructor.apply(this, arguments);
    }

    LineChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    LineChartView.prototype.render = function() {
      this.clear_container();
      return this.render_line_chart();
    };

    LineChartView.prototype.render_line_chart = function() {
      return $.jqplot(this.container_id(), this.model.results(), this.chart_opts());
    };

    LineChartView.prototype.chart_opts = function() {
      var out;
      out = {
        seriesColors: this.model.colors(),
        highlighter: this.defaults.highlighter,
        grid: this.defaults.grid,
        legend: this.create_legend({
          num_columns: 2,
          offset: 20
        }),
        seriesDefaults: {
          lineWidth: 1.5,
          showMarker: false,
          yaxis: 'y2axis',
          pointLabels: {
            show: false
          }
        },
        axes: {
          xaxis: {
            numberTicks: 2,
            tickOptions: {
              fontSize: this.defaults.font_size,
              showGridline: false
            }
          },
          y2axis: {
            rendererOptions: {
              forceTickAt0: true
            },
            tickOptions: {
              formatString: "%." + (this.significant_digits()) + "f&nbsp;" + (this.model.get('unit'))
            }
          }
        }
      };
      return out;
    };

    return LineChartView;

  })(BaseChartView);

}).call(this);
