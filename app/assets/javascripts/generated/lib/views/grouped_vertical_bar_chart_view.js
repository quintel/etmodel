/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/grouped_vertical_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.GroupedVerticalBarChartView = (function(_super) {

    __extends(GroupedVerticalBarChartView, _super);

    function GroupedVerticalBarChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_chart = __bind(this.render_chart, this);
      this.render = __bind(this.render, this);
      GroupedVerticalBarChartView.__super__.constructor.apply(this, arguments);
    }

    GroupedVerticalBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    GroupedVerticalBarChartView.prototype.render = function() {
      this.clear_container();
      return this.render_chart();
    };

    GroupedVerticalBarChartView.prototype.result_serie = function() {
      return _.flatten(this.model.value_pairs());
    };

    GroupedVerticalBarChartView.prototype.ticks = function() {
      var ticks;
      ticks = [];
      this.model.series.each(function(serie) {
        ticks.push(serie.result()[0][0]);
        return ticks.push(serie.result()[1][0]);
      });
      return ticks;
    };

    GroupedVerticalBarChartView.prototype.results = function() {
      return [this.result_serie()];
    };

    GroupedVerticalBarChartView.prototype.render_chart = function() {
      return this.jqplot(this.container_id(), this.results(), this.chart_opts());
    };

    GroupedVerticalBarChartView.prototype.chart_opts = function() {
      var out;
      out = {
        grid: this.defaults.grid,
        highlighter: this.defaults.highlighter,
        stackSeries: true,
        seriesColors: this.model.colors(),
        seriesDefaults: {
          renderer: $.jqplot.BarRenderer,
          rendererOptions: {
            groups: this.model.series.length,
            barWidth: 20
          },
          pointLabels: {
            show: false
          },
          yaxis: 'y2axis',
          shadow: this.defaults.shadow
        },
        axesDefaults: {
          tickOptions: {
            fontSize: this.defaults.font_size
          }
        },
        axes: {
          xaxis: {
            ticks: this.ticks()({
              rendererOptions: {
                groupLabels: this.model.labels()
              }
            }),
            renderer: $.jqplot.CategoryAxisRenderer,
            tickOptions: {
              showGridline: false,
              markSize: 0,
              pad: 1.00
            }
          },
          y2axis: {
            tickOptions: {
              formatString: "%d&nbsp;" + (this.parsed_unit())
            }
          }
        }
      };
      return out;
    };

    return GroupedVerticalBarChartView;

  })(BaseChartView);

}).call(this);
