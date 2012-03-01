/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 14:32:39 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/bezier_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BezierChartView = (function(_super) {

    __extends(BezierChartView, _super);

    function BezierChartView() {
      this.render = __bind(this.render, this);
      BezierChartView.__super__.constructor.apply(this, arguments);
    }

    BezierChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    BezierChartView.prototype.render = function() {
      this.clear_container();
      return InitializeBezier(this.model.get("container"), this.scaled_results(), this.model.get("growth_chart"), this.parsed_unit(), this.model.colors(), this.model.labels());
    };

    BezierChartView.prototype.scaled_results = function() {
      var scale;
      scale = this.data_scale();
      return _.map(this.model.results(), function(gquery) {
        return _.map(gquery, function(pair) {
          return [pair[0], Metric.scale_value(pair[1], scale)];
        });
      });
    };

    return BezierChartView;

  })(BaseChartView);

}).call(this);
