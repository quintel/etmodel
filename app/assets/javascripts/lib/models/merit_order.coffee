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


