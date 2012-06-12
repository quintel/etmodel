class @ScatterChartSerie extends Backbone.Model
  initialize : ->
    # the name composition should be defined somewhere else
    key = @get 'gquery_key'
    query_x = "#{key}_emissions"
    query_y = "#{key}_costs"

    @set
      gquery_x: gqueries.find_or_create_by_key query_x
      gquery_y: gqueries.find_or_create_by_key query_y

  result : ->
    return [
      @get('gquery_x').future_value(),
      @get('gquery_y').future_value()
    ]

class @ScatterChartSeries extends Backbone.Collection
  model : ScatterChartSerie

  gqueries: =>
    out = []
    @each (s) ->
      out.push s.get('gquery_x')
      out.push s.get('gquery_y')
    out
