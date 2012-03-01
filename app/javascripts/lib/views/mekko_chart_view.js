/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 15:34:25 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/mekko_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.MekkoChartView = (function(_super) {

    __extends(MekkoChartView, _super);

    function MekkoChartView() {
      this.render = __bind(this.render, this);
      MekkoChartView.__super__.constructor.apply(this, arguments);
    }

    MekkoChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    MekkoChartView.prototype.render = function() {
      this.clear_container();
      return InitializeMekko(this.model.get("container"), this.results(), this.parsed_unit(), this.colors(), this.labels(), this.group_labels());
    };

    MekkoChartView.prototype.results = function() {
      var results, series, smallest_scale, start_scale, values;
      start_scale = 3;
      series = {};
      values = [];
      this.model.series.each(function(serie) {
        var group;
        group = serie.get('group');
        if (group) {
          if (!series[group]) series[group] = [];
          series[group].push(serie.result_pairs()[0]);
          return values.push(serie.result_pairs()[0]);
        }
      });
      smallest_scale = Metric.scaled_scale(_.sum(series), start_scale);
      results = _.map(series, function(sector_values, sector) {
        return _.map(sector_values, function(value) {
          return Metric.scaled_value(value, start_scale, smallest_scale);
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

    return MekkoChartView;

  })(BaseChartView);

}).call(this);
