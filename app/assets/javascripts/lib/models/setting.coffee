class @Setting extends Backbone.Model
  url: -> '/settings'

  # Always use PUT requests
  isNew : -> false

  get_scaling: =>
    @get('scaling') || @get('area_scaling')

  # Used by the bio-footprint dashboard item
  country: => @get('area_code').split('-')[0]

  # Updates the list of locked charts and persists to the server.
  update_locked_chart_list: (charts) ->
    @save(
      locked_charts:
        charts.where(locked: true).map((chart) -> chart.lock_list_id()))

  charts_enabled: ->
    window.globals.charts_enabled

  # Is MO enabled?
  merit_order_enabled: ->
    try
      values = App.input_elements.user_values.settings_enable_merit_order
      values? && (if values.user? then values.user else values.default) == 1
    catch error
      # handles uninitialized user values hash.
      # TODO: use deferred object
      false

  # Returns a promise which resolves to whether the merit order is enabled. The promise will resolve
  # immediately if the value is known, otherwise it will resolve when data is available.
  merit_order_enabled_promise: ->
    def = new $.Deferred

    try
      values = App.input_elements.user_values.settings_enable_merit_order
      def.resolve(values? && (if values.user? then values.user else values.default) == 1)
    catch error
      App.input_elements.on 'change', (model) =>
        if App.input_elements.user_values &&
            App.input_elements.user_values.hasOwnProperty('settings_enable_merit_order')
          values = App.input_elements.user_values.settings_enable_merit_order
          def.resolve(values? && (if values.user? then values.user else values.default) == 1)

    def.promise()

  toggle_merit_order: =>
    new_value = if @merit_order_enabled() then 0 else 1
    # if the slider is already on screen
    if slider = App.input_elements.find_by_key 'settings_enable_merit_order'
      slider.set 'user_value', new_value
    # Otherwise let's update the user_values hash and fire an API request
    else
      App.input_elements.user_values.settings_enable_merit_order.user = new_value
      App.call_api
        settings_enable_merit_order: new_value
