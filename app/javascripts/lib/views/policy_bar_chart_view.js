/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 15:55:33 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/policy_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.PolicyBarChartView = (function(_super) {

    __extends(PolicyBarChartView, _super);

    function PolicyBarChartView() {
      this.render = __bind(this.render, this);
      PolicyBarChartView.__super__.constructor.apply(this, arguments);
    }

    PolicyBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    PolicyBarChartView.prototype.render = function() {
      this.clear_container();
      return InitializePolicyBar(this.model.get("container"), this.result_serie1(), this.result_serie2(), this.ticks(), this.model.series.length, this.parsed_unit(), this.model.colors(), this.model.labels());
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

    PolicyBarChartView.prototype.ticks = function() {
      var ticks;
      ticks = [];
      this.model.series.each(function(serie) {
        ticks.push(serie.result()[0][0]);
        return ticks.push(serie.result()[1][0]);
      });
      return ticks;
    };

    return PolicyBarChartView;

  })(BaseChartView);

}).call(this);
