/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 14:20:34 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/vertical_stacked_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.VerticalStackedBarChartView = (function(_super) {

    __extends(VerticalStackedBarChartView, _super);

    function VerticalStackedBarChartView() {
      this.render = __bind(this.render, this);
      VerticalStackedBarChartView.__super__.constructor.apply(this, arguments);
    }

    VerticalStackedBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    VerticalStackedBarChartView.prototype.render = function() {
      this.clear_container();
      return InitializeVerticalStackedBar(this.model.get("container"), this.results(), this.ticks(), this.filler(), this.model.get('show_point_label'), this.parsed_unit(), this.model.colors(), this.model.labels());
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

    return VerticalStackedBarChartView;

  })(BaseChartView);

}).call(this);
