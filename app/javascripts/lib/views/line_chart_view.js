/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 15:47:45 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/line_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.LineChartView = (function(_super) {

    __extends(LineChartView, _super);

    function LineChartView() {
      this.render = __bind(this.render, this);
      LineChartView.__super__.constructor.apply(this, arguments);
    }

    LineChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    LineChartView.prototype.render = function() {
      this.clear_container();
      return InitializeLine(this.model.get("container"), this.model.results(), this.model.get('unit'), this.model.colors(), this.model.labels());
    };

    return LineChartView;

  })(BaseChartView);

}).call(this);
