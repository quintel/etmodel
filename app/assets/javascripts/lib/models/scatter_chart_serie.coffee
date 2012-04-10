class @ScatterChartSerie extends Backbone.Model
  initialize : ->
    # the name composition should be defined somewhere else
    key = @get 'gquery_key'
    query_x = "#{key}_emissions"
    query_y = "#{key}_costs"

    @set
      gquery_x: new Gquery({key : query_x}),
      gquery_y: new Gquery({key : query_y})

  result : ->
    return [
      @get('gquery_x').get('future_value'),
      @get('gquery_y').get('future_value')
    ]

class @ScatterChartSeries extends Backbone.Collection
  model : ScatterChartSerie
