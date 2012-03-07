/* DO NOT MODIFY. This file was compiled Wed, 07 Mar 2012 12:57:20 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/views/block_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BlockChartView = (function(_super) {

    __extends(BlockChartView, _super);

    function BlockChartView() {
      this.render = __bind(this.render, this);
      BlockChartView.__super__.constructor.apply(this, arguments);
    }

    BlockChartView.prototype.initialize = function() {
      return this.initialize_defaults();
    };

    BlockChartView.prototype.render = function() {
      $("a.select_chart").hide();
      $("a.toggle_chart_format").hide();
      return update_block_charts(this.model.series.map(function(serie) {
        return serie.result();
      }));
    };

    BlockChartView.prototype.can_be_shown_as_table = function() {
      return false;
    };

    return BlockChartView;

  })(BaseChartView);

}).call(this);
