/* DO NOT MODIFY. This file was compiled Wed, 21 Mar 2012 15:01:41 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/vertical_bar_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.VerticalBarChartView = (function(_super) {

    __extends(VerticalBarChartView, _super);

    function VerticalBarChartView() {
      this.render = __bind(this.render, this);
      VerticalBarChartView.__super__.constructor.apply(this, arguments);
    }

    VerticalBarChartView.prototype.render = function() {
      this.clear_container();
      return this.render_chart();
    };

    VerticalBarChartView.prototype.results = function() {
      var result, results, target_serie, x;
      results = this.results_with_1990();
      target_serie = this.model.target_series()[0];
      result = target_serie.result()[1][1];
      x = parseFloat(target_serie.get('target_line_position'));
      results.push([[x - 0.4, result], [x + 0.4, result]]);
      return results;
    };

    VerticalBarChartView.prototype.results_with_1990 = function() {
      var result;
      result = this.model.results();
      return [[result[0][1][1], result[1][0][1], result[1][1][1]]];
    };

    VerticalBarChartView.prototype.ticks = function() {
      return [1990, App.settings.get("start_year"), App.settings.get("end_year")];
    };

    VerticalBarChartView.prototype.filler = function() {
      return [{}];
    };

    VerticalBarChartView.prototype.parsed_unit = function() {
      return 'MT';
    };

    VerticalBarChartView.prototype.can_be_shown_as_table = function() {
      return false;
    };

    return VerticalBarChartView;

  })(VerticalStackedBarChartView);

}).call(this);
