/* DO NOT MODIFY. This file was compiled Fri, 02 Mar 2012 08:26:03 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/grouped_vertical_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.GroupedVerticalBarChartView = (function(_super) {

    __extends(GroupedVerticalBarChartView, _super);

    function GroupedVerticalBarChartView() {
      this.render = __bind(this.render, this);
      GroupedVerticalBarChartView.__super__.constructor.apply(this, arguments);
    }

    GroupedVerticalBarChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    GroupedVerticalBarChartView.prototype.render = function() {
      this.clear_container();
      return InitializeGroupedVerticalBar(this.model.get("container"), this.result_serie(), this.ticks(), this.model.series.length, this.parsed_unit(), this.model.colors(), this.model.labels());
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

    return GroupedVerticalBarChartView;

  })(BaseChartView);

}).call(this);
