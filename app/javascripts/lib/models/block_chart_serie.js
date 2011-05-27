var BlockChartSerie = Backbone.Model.extend({
  initialize : function() {
    var cost_gql_query = this.get('gquery_key') + "total_cost_per_mwh_electricity)),1)";
    var investment_gql_query = this.get('gquery_key') + 
      "initial_investment_costs_per_mw_electricity)),DIVIDE(1,MILLIONS))";

    this.set({
      gquery_cost : new Gquery({key : cost_gql_query}),
      gquery_investment : new Gquery({key : investment_gql_query})
    });
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