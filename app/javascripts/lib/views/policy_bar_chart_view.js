/* DO NOT MODIFY. This file was compiled Tue, 06 Mar 2012 09:49:09 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/policy_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.PolicyBarChartView = (function(_super) {

    __extends(PolicyBarChartView, _super);

    function PolicyBarChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_chart = __bind(this.render_chart, this);
      this.results = __bind(this.results, this);
      this.render = __bind(this.render, this);
      PolicyBarChartView.__super__.constructor.apply(this, arguments);
    }

    PolicyBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    PolicyBarChartView.prototype.render = function() {
      this.clear_container();
      return this.render_chart();
    };

    PolicyBarChartView.prototype.result_serie1 = function() {
      var out;
      out = _.flatten(this.model.value_pairs());
      if (this.model.get("percentage")) {
        out = _(out).map(function(x) {
          return x * 100;
        });
      }
      return out;
    };

    PolicyBarChartView.prototype.result_serie2 = function() {
      return _.map(this.result_serie1(), function(r) {
        return 100 - r;
      });
    };

    PolicyBarChartView.prototype.results = function() {
      return [this.result_serie1(), this.result_serie1()];
    };

    PolicyBarChartView.prototype.ticks = function() {
      var ticks;
      ticks = [];
      this.model.series.each(function(serie) {
        ticks.push(serie.result()[0][0]);
        return ticks.push(serie.result()[1][0]);
      });
      return ticks;
    };

    PolicyBarChartView.prototype.render_chart = function() {
      return $.jqplot(this.container_id(), this.results(), this.chart_opts());
    };

    PolicyBarChartView.prototype.chart_opts = function() {
      var out;
      out = {
        grid: default_grid,
        stackSeries: true,
        seriesColors: [this.model.colors()[0], "#CCCCCC"],
        seriesDefaults: {
          renderer: $.jqplot.BarRenderer,
          rendererOptions: {
            groups: this.model.series.length,
            barWidth: 35
          },
          pointLabels: {
            stackedValue: true
          },
          yaxis: 'y2axis',
          shadow: shadow
        },
        series: [
          {
            pointLabels: {
              ypadding: -15
            }
          }, {
            pointLabels: {
              ypadding: 9000
            }
          }
        ],
        axesDefaults: {
          tickOptions: {
            fontSize: font_size
          }
        },
        axes: {
          xaxis: {
            ticks: this.ticks(),
            rendererOptions: {
              groupLabels: this.model.labels()
            },
            renderer: $.jqplot.CategoryAxisRenderer,
            tickOptions: {
              showGridline: false,
              pad: 3.00
            }
          },
          y2axis: {
            ticks: [0, 100],
            tickOptions: {
              formatString: '%d\%'
            }
          }
        }
      };
      return out;
    };

    return PolicyBarChartView;

  })(BaseChartView);

}).call(this);
