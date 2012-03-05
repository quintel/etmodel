class @ChartSerie extends Backbone.Model
  initialize : ->
    gquery = new Gquery({key : this.get('gquery_key')})
    @set({gquery : gquery})

  result: ->
    @get('gquery').result()

  result_pairs: ->
    result = @result()
    [result[0][1],result[1][1]]

  future_value: ->
    @result()[1][1]

  present_value: ->
    @result()[0][1]

class @ChartSeries extends Backbone.Collection
  model : ChartSerie
