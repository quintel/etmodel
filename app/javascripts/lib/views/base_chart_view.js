/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 14:07:53 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/base_chart_view.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BaseChartView = (function(_super) {

    __extends(BaseChartView, _super);

    function BaseChartView() {
      BaseChartView.__super__.constructor.apply(this, arguments);
    }

    BaseChartView.prototype.initialize_defaults = function() {
      return this.model.bind('change', this.render);
    };

    BaseChartView.prototype.clear_container = function() {
      return this.model.container_node().empty();
    };

    BaseChartView.prototype.max_value = function() {
      var max_value, sum_future, sum_present, target_results;
      sum_present = _.reduce(this.model.values_present(), function(sum, v) {
        var _ref;
        return sum + ((_ref = v > 0) != null ? _ref : {
          v: 0
        });
      });
      sum_future = _.reduce(this.model.values_future(), function(sum, v) {
        var _ref;
        return sum + ((_ref = v > 0) != null ? _ref : {
          v: 0
        });
      });
      target_results = _.flatten(this.model.target_results());
      return max_value = _.max($.merge([sum_present, sum_future], target_results));
    };

    BaseChartView.prototype.parsed_unit = function() {
      var unit;
      unit = this.model.get('unit');
      return Metric.scale_unit(this.max_value(), unit);
    };

    BaseChartView.prototype.data_scale = function() {
      return Metric.power_of_thousand(this.max_value());
    };

    return BaseChartView;

  })(Backbone.View);

}).call(this);
