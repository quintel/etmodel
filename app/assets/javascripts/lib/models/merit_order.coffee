class @MeritOrder
  constructor: (app) ->
    @app = app
    @gquery = gqueries.find_or_create_by_key 'dashboard_profitability'

  dashboard_value: =>
    return null unless @app.settings.merit_order_enabled()
    total = @total_available_capacity()
    return null if total == 0
    @profitable_capacity() / @total_available_capacity()

  # Sum of the [conditionally_]profitable dispatchable capacities
  #
  profitable_capacity: =>
    sum = 0
    q = @gquery.future_value()
    for c in _.select(_.values(q), (v) ->
      v.profitability == 'profitable' ||
      v.profitability == 'conditionally_profitable' )
      sum += c.capacity
    sum

  total_available_capacity: =>
    sum = 0
    q = @gquery.future_value()
    for c in _.values(q)
      sum += c.capacity
    sum
