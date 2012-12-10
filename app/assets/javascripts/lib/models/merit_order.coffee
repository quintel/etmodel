class @MeritOrder
  constructor: (app) ->
    @app = app

  update_dashboard_item: ->
    $el = $('#constraint_14 strong')
    if @app.settings.merit_order_enabled()
      $el.html('...')
    else
      $el.html('-')

