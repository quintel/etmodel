class @MeritOrder
  constructor: (app) ->
    @app = app
    @gquery = gqueries.find_or_create_by_key 'dashboard_merit_order'

  dashboard_value: =>
    return null unless @app.settings.merit_order_enabled()
    q = @gquery.future_value()
    profitables = _.select(_.values(q), (v) -> v.profitable == 'profitable' ).length
    tot = _.keys(q).length
    profitables/tot

  format_table: =>
    tmpl = _.template $('#merit-order-table-template').html()
    items = []
    for key, values of @gquery.future_value()
      value = if @app.settings.merit_order_enabled()
        values.profitable
      else
        'N/A'
      continue if values.capacity == 0
      items.push
        profitable: value
        key: key
        position: values.position
        capacity: values.capacity
        full_load_hours: values.full_load_hours
        profits: values.profits


    sorted_items = items.sort(@sorting_function)

    data = {series: sorted_items}

    $('#merit-order-table').html tmpl(data)
    true

  sorting_function: (a,b) =>
    pa = @profitability_index a
    pb = @profitability_index b
    ca = a.profits
    cb = b.profits
    # sort by profitability (profitability < c.p < unprofitable)
    if pa != pb
      return -1 if pa < pb
      return 1 if pa > pb
      return 0
    # sort by descending profits
    return -1 if ca > cb
    return 1 if ca < cb
    return 0

  profitability_index: (x) ->
    switch x.profitable
      when 'profitable' then 0
      when 'conditionally_profitable' then 1
      when 'unprofitable' then 2

