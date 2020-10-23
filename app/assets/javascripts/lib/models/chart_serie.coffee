class @ChartSerie extends Backbone.Model
  initialize : ->
    gquery = gqueries.find_or_create_by_key @get('gquery_key')
    @set {gquery : gquery, skip: false}

  # The safe_* methods convert bad values to 0
  safe_future_value:  -> @get('gquery').safe_future_value()
  safe_present_value: -> @get('gquery').safe_present_value()

  present_value: => @get('gquery').present_value()
  future_value: => @get('gquery').future_value()

class @ChartSeries extends Backbone.Collection
  model : ChartSerie

  with_gquery: (gquery) ->
    @find (s) -> s.get('gquery_key') == gquery

  gqueries: => @map (s) -> s.get('gquery')
