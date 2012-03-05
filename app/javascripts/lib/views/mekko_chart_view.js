/* DO NOT MODIFY. This file was compiled Mon, 05 Mar 2012 12:54:06 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/mekko_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.MekkoChartView = (function(_super) {

    __extends(MekkoChartView, _super);

    function MekkoChartView() {
      this.chart_opts = __bind(this.chart_opts, this);
      this.render_mekko = __bind(this.render_mekko, this);
      this.render = __bind(this.render, this);
      MekkoChartView.__super__.constructor.apply(this, arguments);
    }

    MekkoChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    MekkoChartView.prototype.render = function() {
      this.clear_container();
      return this.render_mekko();
    };

    MekkoChartView.prototype.results = function() {
      var results, scale, series;
      scale = this.data_scale();
      series = {};
      this.model.series.each(function(serie) {
        var group, val;
        group = serie.get('group');
        if (group) {
          if (!series[group]) series[group] = [];
          val = serie.result_pairs()[0];
          return series[group].push(val);
        }
      });
      results = _.map(series, function(sector_values, sector) {
        return _.map(sector_values, function(value) {
          return Metric.scale_value(value, scale);
        });
      });
      return results;
    };

    MekkoChartView.prototype.colors = function() {
      return _.uniq(this.model.colors());
    };

    MekkoChartView.prototype.labels = function() {
      var labels;
      labels = this.model.labels();
      return _.uniq(labels);
    };

    MekkoChartView.prototype.group_labels = function() {
      var group_labels;
      group_labels = this.model.series.map(function(serie) {
        return serie.get('group_translated');
      });
      return _.uniq(group_labels);
    };

    MekkoChartView.prototype.render_mekko = function() {
      $.jqplot(this.model.get("container"), this.results(), this.chart_opts());
      $(".jqplot-xaxis").css({
        "margin-left": -10,
        "margin-top": 0
      });
      $(".jqplot-table-legend").css({
        "top": 340
      });
      return $(".jqplot-point-label").html(null);
    };

    MekkoChartView.prototype.chart_opts = function() {
      var out;
      out = {
        grid: default_grid,
        legend: create_legend(3, 's', this.labels(), 155),
        seriesDefaults: {
          renderer: $.jqplot.MekkoRenderer,
          rendererOptions: {
            borderColor: "#999999"
          }
        },
        seriesColors: this.colors(),
        axesDefaults: {
          renderer: $.jqplot.MekkoAxisRenderer,
          tickOptions: {
            fontSize: font_size,
            markSize: 0
          }
        },
        axes: {
          xaxis: {
            barLabels: this.group_labels(),
            rendererOptions: {
              barLabelOptions: {
                fontSize: font_size,
                angle: -45
              },
              barLabelRenderer: $.jqplot.CanvasAxisLabelRenderer
            },
            tickOptions: {
              formatString: '&nbsp;'
            }
          },
          x2axis: {
            show: true,
            tickMode: 'bar',
            tickOptions: {
              formatString: '%d&nbsp;' + this.parsed_unit()
            },
            rendererOptions: {
              barLabelOptions: {
                angle: 90
              }
            }
          }
        }
      };
      return out;
    };

    return MekkoChartView;

  })(BaseChartView);

}).call(this);
