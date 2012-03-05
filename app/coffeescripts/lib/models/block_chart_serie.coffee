class @BlockChartSerie extends Backbone.Model
  initialize : ->
    # the block chart has a different behavious; its gqueries follow a naming
    # convention
    key = @get 'gquery_key'
    cost_gql_query = "costs_of_#{key}_in_overview_costs_of_electricity_production"
    investment_gql_query = "investment_for_#{key}_in_overview_costs_of_electricity_production"

    @set
      gquery_cost:       new Gquery({key : cost_gql_query}),
      gquery_investment: new Gquery({key : investment_gql_query})

  result : ->
    return [
      @get('id'),
      @get('gquery_cost').get('present_value'),
      @get('gquery_investment').get('present_value')
    ]

class @BlockChartSeries extends Backbone.Collection
  model : BlockChartSerie
