# This is used to disable the save/reset scenario menu items while awaiting
# a scenario ID from ETEngine. See quintel/etengine#542. We need to hold on to
# the function so that the event can be unbound once the ID is available.
disabledSetting = (event) -> false

class @AppView extends Backbone.View
  initialize: ->
    @settings    = new Setting({api_session_id: globals.api_session_id})
    @sidebar     = new SidebarView()
    @scenario    = new Scenario()
    @scenarioNav = new ScenarioNavView(model: @scenario, el: $('#scenario-nav'))
    @router      = new Router()
    @analytics   = new Analytics(window.ga)
    @accessToken = null

    if globals.access_token
      @accessToken = new AccessToken(
        globals.access_token.token,
        new Date(globals.access_token.expires_at * 1000)
      )
      @configureTokenRefresh(@accessToken)
    else
      @accessToken = new GuestToken()

    @api = new ApiGateway
      api_path:           globals.api_url
      api_proxy_path:     globals.api_proxy_url
      scenario_id:        globals.api_session_id
      beforeLoading:      @showLoading
      afterLoading:       @hideLoading
      source:             'ETM'
      preset_scenario_id: globals.settings.preset_scenario_id
      area_code:          globals.settings.area_code
      end_year:           globals.settings.end_year
      scale:              globals.settings.scaling
      access_token:       if globals.access_token then globals.access_token.token else undefined

    # Store the scenario id
    @api.ensure_id().done (id) =>
      if id != globals.api_session_id
        @settings.save({ api_session_id: id })
      @scenario.set(id: id)

  # (Re)builds the list of sliders and renders them. This is usually called by
  # play.js.erb
  #
  setup_sliders: =>
    if @input_elements
      @input_elements.off "change"
      @input_elements.reset()
      InputElement.Balancer.balancers = {}
    @input_elements = new InputElementList()
    @input_elements.on "change", @handleInputElementsUpdate
    @loadCustomCurveStates()

    deferred = @user_values()
      .done (args...) =>
        @input_elements.initialize_user_values(args...)
        @setup_checkboxes()
      .fail @handle_ajax_error

    wrapper = $('#accordion_wrapper')

    # Create heat network order.
    if (heat_order = wrapper.find('#heat-network-options')).length
      @heat_order = new UserSortable(
        heat_order,
        'heat_network_order',
        { subtype: heat_order.data('subtype') },
        { capacity: true }
      )
      @heat_order.render()

    # Create forecast storage order.
    if (forecast_storage_order = wrapper.find('#forecast-storage-order')).length
      new UserSortable(
        forecast_storage_order,
        'forecast_storage_order',
        {},
        { capacity: true, sortable: true }
      ).render()

    # Create forecast storage order.
    if (households_heating_producer_order = wrapper.find('#households-heating-producer-order')).length
      new UserSortable(
        households_heating_producer_order,
        'households_space_heating_producer_order',
        {},
        { capacity: true }
      ).render()

    if (curve_upload = wrapper.find('.single-curve-upload')).length
      curveCollectionDef = @customCurves()
      userScenariosArray = @userScenarios()

      curve_upload.each (_index, element) ->
        CustomCurveChooserView.setupWithWrapper(
          $(element),
          curveCollectionDef,
          userScenariosArray
        )

    if (curve_upload = wrapper.find('.multi-curve-upload')).length > 0
      curveCollectionDef = @customCurves()
      userScenariosDef = @userScenarios()

      curve_upload.each (_index, element) ->
        MultiCurveChooserView.setupWithWrapper(element, curveCollectionDef, userScenariosDef)

    deferred

  configureTokenRefresh: (accessToken) ->
    return unless accessToken

    refresh = () ->
      console.log('Refreshing access token')
      window.location.reload()

    expiresInMS = accessToken.expiresAt.getTime() - new Date().getTime();

    # A random number of seconds between 0 and 10 is added to the refresh time. This avoids multiple
    # browser tabs refreshing simultaneously and causing unnecessary token refreshes.
    refreshInMS = Math.max(expiresInMS - 60000 + Math.round(Math.random() * 10000), 0)

    if globals.debug_js
      console.log(
        "Access token expires at #{accessToken.expiresAt.toISOString()} and will refresh " +
        "in #{Math.round(refreshInMS/100/60)/10} minutes (#{Math.floor(refreshInMS/1000)}s)"
      )

    window.setTimeout(refresh, refreshInMS)

  # Returns a deferred object on which the .done() method can be called
  #
  user_values: =>
    return @_user_values_dfd if @_user_values_dfd
    @_user_values_dfd = $.Deferred (dfd) =>
      @api.user_values
        extras: !! App.settings.get('scaling')
        success: dfd.resolve
        error: dfd.reject
    @_user_values_dfd

  # At this point we have all the settings initialized.
  bootstrap: =>
    Backbone.history.start({pushState: true, root: '/scenario'})
    @sidebar.bootstrap()

    unless Backbone.history.getFragment().match(/^reports\//)
      @router.update_sidebar()

    # If a "change dashboard" button is present, set up the DashboardChanger.
    dashChangeEl = $('#dashboard_change')
    if dashChangeEl.length > 0
      new DashboardChangerView(dashChangeEl)

    window.charts = @charts = new ChartList()
    @accordion = new Accordion()
    @accordion.setup()

    @scenarioNav.render()

    if Backbone.history.getFragment().match(/^reports\//)
      @handle_ajax_error = ReportView.onLoadingError

      @setup_sliders().done ->
        new ReportView(window.reportData).renderInto($('#report'))
    else
      @charts.load_initial_charts(@settings.get('locked_charts'))

  reset_scenario: =>
    @settings.set({
      api_session_id: null,
      preset_scenario_id: null,
      network_parts_affected: []
      }, { silent: true } )
    @deferred_scenario_id = null
    i.set({user_value: null}, {silent: true}) for i in @input_elements.models
    @setup_sliders()

  # Used on the console for debugging
  scenario_url: =>
    "#{globals.api_url}/inspect/#{@api.scenario_id}"

  # Prepares the Merit Order checkboxes
  setup_checkboxes: =>
    # Prevent double event bindings
    return if @checkboxes_initialized
    @update_merit_order_checkbox()
    # IE doesn't bubble onChange until the checkbox loses focus
    $(document).on 'click', "#settings_use_merit_order", @settings.toggle_merit_order

    @checkboxes_initialized = true

  call_api: (input_params, options = {}) =>
    @api.update
      queries:  window.gqueries.keys(),
      inputs:   input_params,
      success: (json, data, textStatus, jqXHR) =>
        @handle_api_result(json, data, textStatus, jqXHR)
        options.success?(json, data, textStatus, jqXHR)
      error: (jqXHR, textStatus, error) =>
        @handle_ajax_error(jqXHR, textStatus, error)
        options.error?(jqXHR, textStatus, error)

  handle_ajax_error: (jqXHR, textStatus, error) ->
    console.log("Something went wrong: " + textStatus)

    if globals.env == 'development' || (globals.env == 'staging' && globals.debug_js)
      body = $('body')

      if !body.hasClass('has-api-error')
        $('body').addClass('has-api-error').append(
          new ApiErrorView(
            status: jqXHR.status
            responseJSON: jqXHR.responseJSON
            responseText: jqXHR.responseText
            scenarioURL:  App.scenario_url()
          ).render()
        )

  handle_api_result: ({results, settings, inputs}, data, textStatus, jqXHR) =>
    # store the last response from api for the turk it debugging tool
    # it is activated by passing ?debug=1 and can be found in the settings
    # menu.
    $("#last_api_response").val(jqXHR.responseText)
    for own key, values of results
      if gquery = window.gqueries.with_key(key)
        gquery.handle_api_result(values)

    @scenario.set({ owner: data.scenario.owner })

    @charts.invoke 'trigger', 'refresh'
    @sidebar.update_bars()

  # Set the update in a cancelable action. When you
  # pull a slider A this method is called. It will call doUpdateRequest
  # after 500ms. When a slider is pulled again, that call will be canceled
  # (so that we don't flood the server). doUpdateRequest will get the dirty
  # sliders, reset all dirtyiness and make an API call.
  handleInputElementsUpdate: =>
    func = $.proxy(@doUpdateRequest, this)
    lockable_fn = -> LockableFunction.deferExecutionIfLocked('update', func)
    Util.cancelableAction('update',  lockable_fn, {'sleepTime': 100})

  # Get the value of all changed sliders. Get the chart. Sends those values to
  # the server.
  doUpdateRequest: =>
    # LiteUI means we're rendering in an iframe.
    # Let the parent window know we're processing a request
    if $('body').hasClass('liteui')
      parent.postMessage('request-started', '*')

    dirtyInputElements = @input_elements.dirty()
    return if dirtyInputElements.length == 0
    input_params = @input_elements.api_update_params()
    @input_elements.reset_dirty()
    @call_api(input_params)
    if (@heat_order)
      @heat_order.render()

  showLoading: ->
    # D3 charts shouldn't be blocked, only jqPlot ones
    $(".chart_holder[data-block_ui_on_refresh=true]:visible").busyBox
      spinner: "<em>Loading</em>"
    $("#dashboard .loading").show()
    $(".arrow").css("opacity", "0.0")

  hideLoading: ->
    $(".chart_holder").busyBox('close')
    $("#dashboard .loading").hide()

    # Done! Also let the parent know
    if $('body').hasClass('liteui')
      parent.postMessage('request-stopped', '*')

  debug: (t) ->
    console.log(t) if globals.debug_js

  # TODO: Move this interface methods to a separate Interface class
  #
  update_merit_order_checkbox: =>
    $(".merit-data-downloads").toggle(@settings.merit_order_enabled())
    $("#settings_use_merit_order").attr('checked', @settings.merit_order_enabled())

  # Gets the collection of custom curves. Returns a deferred as the collection
  # will not yet be initialized the first time `customCurves` is invoked. The
  # deferred will resolve with the collection once the data is available, or
  # immediately if it has eben initialized previously.
  customCurves: =>
    if @customCurvesDeferred
      return @customCurvesDeferred.promise()
    else
      @customCurvesDeferred = $.Deferred()

      # Ajax request.
      @api.ensure_id().done (id) =>
        req = $.ajax(
          url: App.scenario.url_path() +
            '/custom_curves?include_internal=true&include_unattached=true'
          headers: @accessToken.headers()
          method: 'GET'
          dataType: 'json'
        )

        req.success((data) =>
          @customCurvesDeferred.resolve(new CustomCurveCollection(data))
        )

    return @customCurvesDeferred.promise()

  userScenarios: =>
    if @userScenariosDeferred
      return @userScenariosDeferred.promise()
    else
      @userScenariosDeferred = $.Deferred()

      req = $.ajax({
        url: '/saved_scenarios',
        method: 'GET'
        headers: @accessToken.headers()
        dataType: 'json'
      })

      req.done((data) =>
        @userScenariosDeferred.resolve(data)
      )

    return @userScenariosDeferred.promise()

  # Triggered exactly once. Loads custom curve states and disables and sliders which are overridden
  # by the curves.
  loadCustomCurveStates: =>
    @customCurves().then((collection) ->
      collection.models.forEach((model) -> model.refreshInputState())
    )

    # Self destruct.
    @loadCustomCurveStates = () =>
