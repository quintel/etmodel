/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 16:34:21 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/grouped_vertical_bar_chart_view.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    _this = this;

  __extends(GroupedVerticalBarChartView, BaseChartView({
    initialize: function() {
      return this.initialize_defaults();
    },
    render: function() {
      _this.clear_container();
      return InitializeGroupedVerticalBar(_this.model.get("container"), _this.result_serie(), _this.ticks(), _this.model.series.length, _this.parsed_unit(), _this.model.colors(), _this.model.labels());
    },
    result_serie: function() {
      return _.flatten(this.model.value_pairs());
    },
    ticks: function() {
      var ticks;
      ticks = [];
      this.model.series.each(function(serie) {
        ticks.push(serie.result()[0][0]);
        return ticks.push(serie.result()[1][0]);
      });
      return ticks;
    }
  }));

}).call(this);
