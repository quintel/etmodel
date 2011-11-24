var BlockChartSerie = Backbone.Model.extend({
  initialize : function() {
    // the block chart has a different behavious; its gqueries follow a naming
    // convention
    var cost_gql_query       = "costs_of_"      + this.get('gquery_key') + "_in_overview_costs_of_electricity_production";
    var investment_gql_query = "investment_for_" + this.get('gquery_key') + "_in_overview_costs_of_electricity_production";

    this.set({
      gquery_cost :       new Gquery({key : this.map_gquery_key_to_id(cost_gql_query)}),
      gquery_investment : new Gquery({key : this.map_gquery_key_to_id(investment_gql_query)})
    });
  },
  
  map_gquery_key_to_id : function(k) {
    return '' + gquery_map[k];
  },

  result : function() {
    return [
      this.get('id'), 
      this.get('gquery_cost').get('present_value'), 
      this.get('gquery_investment').get('present_value')
    ];
  }
});

var BlockChartSeries = Backbone.Collection.extend({
  model : BlockChartSerie
});