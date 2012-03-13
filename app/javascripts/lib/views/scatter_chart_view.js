/* DO NOT MODIFY. This file was compiled Tue, 13 Mar 2012 09:46:59 GMT from
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
        var future, label, pres;
        pres = serie.result()[0];
        future = serie.result()[1];
        label = serie.get('label');
        return [[pres, future, label]];
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
          num_columns: 3,
          offset: 60
        }),
        seriesDefaults: {
          lineWidth: 1.5,
          showMarker: true,
          markerOptions: {
            size: 15.0,
            style: 'filledCircle'
          },
          yaxis: 'yaxis',
          pointLabels: {
            show: false
          }
        },
        axesDefaults: {
          labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
          labelOptions: {
            fontSize: '13px',
            textColor: "#000000"
          },
          rendererOptions: {
            forceTickAt0: true
          },
          numberTicks: 5,
          tickOptions: {
            fontSize: this.defaults.font_size,
            showGridline: true,
            formatString: "%.1f"
          }
        },
        axes: {
          xaxis: {
            label: this.x_axis_unit()
          },
          yaxis: {
            label: this.y_axis_unit()
          }
        },
        highlighter: {
          show: true,
          sizeAdjust: 7.5,
          yvalues: 3,
          formatString: '(%s, %s) %s',
          tooltipLocation: 'ne'
        }
      };
      return out;
    };

    return ScatterChartView;

  })(BaseChartView);

}).call(this);
