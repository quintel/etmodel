// result_cost = Current.gql.query("#{block.key}total_cost_per_mje)),MJ_TO_MHW)")
// result_investment = (Current.gql.query("#{block.key}overnight_investment_co2_capture_per_mj_s)),DIVIDE(1,MILLIONS))")) + (Current.gql.query("#{block.key}overnight_investment_ex_co2_per_mj_s)),DIVIDE(1,MILLIONS))"))
// data_array << [block.id,result_cost.round(1),result_investment.round(1)]

var BlockChartSerie = Backbone.Model.extend({
  initialize : function() {
    var cost_gql_query = this.get('gquery_key') + "total_cost_per_mje)),MJ_TO_MHW)";
    var investment_gql_query = this.get('gquery_key') + 
      "overnight_investment_co2_capture_per_mj_s+overnight_investment_ex_co2_per_mj_s)),DIVIDE(1,MILLIONS))";

    this.set({
      gquery_cost : new Gquery({key : cost_gql_query}),
      gquery_investment : new Gquery({key : investment_gql_query})
    });
  },

  result : function() {
    return [this.get('id'), this.get('gquery_cost').get('present_value'), this.get('gquery_investment').get('present_value')];
  }
});

var ChartSerie = Backbone.Model.extend({
  initialize : function() {
    var gquery = new Gquery({key : this.get('gquery_key')});
    this.set({gquery : gquery});
  },

  result : function() {
    return this.get('gquery').result();
  },

  result_pairs : function() {
    var result = this.result();
    return [result[0][1],result[1][1]];
  }
});

var ChartSeries = Backbone.Collection.extend({
  model : ChartSerie
})

var BlockChartSeries = Backbone.Collection.extend({
  model : BlockChartSerie
})
