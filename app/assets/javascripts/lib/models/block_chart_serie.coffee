class @BlockChartSerie extends Backbone.Model
  initialize : ->
    # the block chart has a different behaviour; its gqueries follow a naming
    # convention
    key = @get 'gquery_key'
    cost_gql_query = "costs_of_#{key}_in_overview_costs_of_electricity_production"
    investment_gql_query = "investment_for_#{key}_in_overview_costs_of_electricity_production"

    @set
      gquery_cost:       gqueries.find_or_create_by_key(cost_gql_query)
      gquery_investment: gqueries.find_or_create_by_key(investment_gql_query)

  result : ->
    return [
      @get('id'),
      @get('gquery_cost').safe_present_value(),
      @get('gquery_investment').safe_future_value()
    ]

class @BlockChartSeries extends Backbone.Collection
  model : BlockChartSerie

  gqueries: =>
    out = []
    @each (s) ->
      out.push s.get('gquery_cost')
      out.push s.get('gquery_investment')
    out
