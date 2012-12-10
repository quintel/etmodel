class @MeritOrder
  constructor: (app) ->
    @app = app
    @gquery = gqueries.find_or_create_by_key 'dashboard_merit_order'

  update_dashboard_item: =>
    $el = $('#constraint_14 strong')
    if @app.settings.merit_order_enabled()
      $el.html  @dashboard_string()
    else
      $el.html('-')

  dashboard_string: =>
    q = @gquery.future_value()
    profitables = _.select(_.values(q), (v) -> v.profitable ).length
    tot = _.keys(q).length

    out = "#{profitables}/#{tot}"

  format_table: =>
    tmpl = _.template $('#merit-order-table-template').html()
    items = []
    for key, values of @gquery.future_value()
      value = if @app.settings.merit_order_enabled()
        values.profitable
      else
        'N/A'
      items.push
        key: key
        profitable: value

    data = {series: items}

    $('#merit-order-table').html tmpl(data)
    true


