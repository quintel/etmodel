class @ChartSerie extends Backbone.Model
  initialize : ->
    gquery = gqueries.find_or_create_by_key @get('gquery_key')
    @set {gquery : gquery}

  # These methods return a sanitized result, where null/undefined are converted
  # to 0
  result: -> @get('gquery').result()
  result_pairs: -> [@present_value(), @future_value()]
  future_value:  -> @result()[1][1]
  present_value: -> @result()[0][1]
  # Some charts, though, use nil values and therefore will rather have the raw
  # result. If the target_query is null then this means that the goal has not
  # been set
  raw_future_value: => @get('gquery').future_value()

class @ChartSeries extends Backbone.Collection
  model : ChartSerie

  with_gquery: (gquery) ->
    @find (s) -> s.get('gquery').get('key') == gquery

  gqueries: =>
    @map (s) -> s.get('gquery')
