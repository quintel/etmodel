/* DO NOT MODIFY. This file was compiled Mon, 05 Mar 2012 16:32:14 GMT from
 * /Users/paozac/Sites/etmodel/app/coffeescripts/lib/models/block_chart_serie.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BlockChartSerie = (function(_super) {

    __extends(BlockChartSerie, _super);

    function BlockChartSerie() {
      BlockChartSerie.__super__.constructor.apply(this, arguments);
    }

    BlockChartSerie.prototype.initialize = function() {
      var cost_gql_query, investment_gql_query, key;
      key = this.get('gquery_key');
      cost_gql_query = "costs_of_" + key + "_in_overview_costs_of_electricity_production";
      investment_gql_query = "investment_for_" + key + "_in_overview_costs_of_electricity_production";
      return this.set({
        gquery_cost: new Gquery({
          key: cost_gql_query
        }),
        gquery_investment: new Gquery({
          key: investment_gql_query
        })
      });
    };

    BlockChartSerie.prototype.result = function() {
      return [this.get('id'), this.get('gquery_cost').get('present_value'), this.get('gquery_investment').get('present_value')];
    };

    return BlockChartSerie;

  })(Backbone.Model);

  this.BlockChartSeries = (function(_super) {

    __extends(BlockChartSeries, _super);

    function BlockChartSeries() {
      BlockChartSeries.__super__.constructor.apply(this, arguments);
    }

    BlockChartSeries.prototype.model = BlockChartSerie;

    return BlockChartSeries;

  })(Backbone.Collection);

}).call(this);
