/* DO NOT MODIFY. This file was compiled Tue, 06 Mar 2012 10:12:24 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/waterfall_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.WaterfallChartView = (function(_super) {

    __extends(WaterfallChartView, _super);

    function WaterfallChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_waterfall = __bind(this.render_waterfall, this);
      this.render = __bind(this.render, this);
      WaterfallChartView.__super__.constructor.apply(this, arguments);
    }

    WaterfallChartView.prototype.initialize = function() {
      this.initialize_defaults();
      return this.HEIGHT = '460px';
    };

    WaterfallChartView.prototype.render = function() {
      this.clear_container();
      return this.render_waterfall();
    };

    WaterfallChartView.prototype.colors = function() {
      var colors;
      colors = this.model.colors();
      colors.push(colors[0]);
      return colors;
    };

    WaterfallChartView.prototype.labels = function() {
      var label, labels;
      labels = this.model.labels();
      label = this.model.get('id') === 51 ? App.settings.get("end_year") : 'Total';
      labels.push(label);
      return labels;
    };

    WaterfallChartView.prototype.results = function() {
      var scale, series;
      scale = this.data_scale();
      series = this.model.series.map(function(serie) {
        var future, present;
        present = serie.present_value();
        future = serie.future_value();
        if (serie.get('group') === 'value') {
          return present;
        } else {
          return future;
        }
      });
      return [series];
    };

    WaterfallChartView.prototype.render_waterfall = function() {
      return $.jqplot(this.model.get("container"), this.results(), this.chart_opts());
    };

    WaterfallChartView.prototype.chart_opts = function() {
      var out;
      return out = {
        seriesVColors: this.colors(),
        grid: this.defaults.grid,
        seriesDefaults: {
          shadow: shadow,
          renderer: $.jqplot.BarRenderer,
          rendererOptions: {
            waterfall: true,
            varyBarColor: true,
            useNegativeColors: false,
            barWidth: 25
          },
          pointLabels: {
            ypadding: -5,
            formatString: '%.0f'
          },
          yaxis: 'y2axis'
        },
        axes: {
          xaxis: {
            renderer: $.jqplot.CategoryAxisRenderer,
            ticks: this.labels(),
            tickRenderer: $.jqplot.CanvasAxisTickRenderer,
            tickOptions: {
              angle: -90,
              showGridline: false,
              fontSize: this.defaults.font_size
            }
          },
          y2axis: {
            rendererOptions: {
              forceTickAt0: true
            },
            tickOptions: {
              formatString: "%.1f&nbsp;" + (this.model.get('unit'))
            }
          }
        }
      };
    };

    return WaterfallChartView;

  })(BaseChartView);

}).call(this);
