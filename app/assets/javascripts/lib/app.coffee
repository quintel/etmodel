# This is used to disable the save/reset scenario menu items while awaiting
# a scenario ID from ETEngine. See quintel/etengine#542. We need to hold on to
# the function so that the event can be unbound once the ID is available.
disabledSetting = (event) -> false

class @AppView extends Backbone.View
  initialize: ->
    @disableIdDependantSettings()

    @settings    = new Setting({api_session_id: globals.api_session_id})
    @sidebar     = new SidebarView()
    @scenario    = new Scenario()
    @router      = new Router()
    @analytics   = new Analytics(window.ga);

    @api = new ApiGateway
      api_path:           globals.api_url
      api_proxy_path:     globals.api_proxy_url
      offline:            globals.standalone
      scenario_id:        globals.api_session_id
      beforeLoading:      @showLoading
      afterLoading:       @hideLoading
      source:             'ETM'
      preset_scenario_id: globals.settings.preset_scenario_id
      area_code:          globals.settings.area_code
      end_year:           globals.settings.end_year
      scale:              globals.settings.scaling

    # Store the scenario id
    @api.ensure_id().done (id) =>
      if id != globals.api_session_id
        @settings.save({ api_session_id: id })
      @enableIdDependantSettings()

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

    deferred = @user_values()
      .done (args...) =>
        @input_elements.initialize_user_values(args...)
        @setup_fce_toggle()
        @setup_checkboxes()
      .fail @handle_ajax_error

    wrapper = $('#accordion_wrapper')

    # Create flexibility order.
    if (sortable = wrapper.find('ul.sortable')).length
      new FlexibilityOrder(sortable[0]).render()

    if (curve_upload = wrapper.find('.curve-upload')).length
      CustomCurveChooserView.setupWithWrapper(curve_upload).render();

    deferred

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

    if Backbone.history.getFragment().match(/^reports\//)
      @handle_ajax_error = ReportView.onLoadingError

      @setup_sliders().done ->
        new ReportView(window.reportData).renderInto($('#report'))
    else
      @charts.load_initial_charts(@settings.get('locked_charts'))

  setup_fce_toggle: ->
    if element = $('.slide .fce-toggle')
      (new FCEToggleView(el: element, model: App.settings)).render()

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
    "#{globals.api_url}/inspect/#{@scenario.api_session_id()}"

  # Prepares the Merit Order abd FCE checkboxes
  setup_checkboxes: =>
    # Prevent double event bindings
    return if @checkboxes_initialized
    @update_merit_order_checkbox()
    # IE doesn't bubble onChange until the checkbox loses focus
    $(document).on 'click', "#settings_use_fce", @settings.toggle_fce
    $(document).on 'click', "#settings_use_merit_order", @settings.toggle_merit_order

    @checkboxes_initialized = true

  call_api: (input_params, options = {}) =>
    @api.update
      queries:  window.gqueries.keys(),
      inputs:   input_params,
      settings:
        use_fce: App.settings.get('use_fce')
      success: (json, data, textStatus, jqXHR) =>
        @handle_api_result(json, data, textStatus, jqXHR)
        options.success?(json, data, textStatus, jqXHR)
      error: (jqXHR, textStatus, error) =>
        @handle_ajax_error(jqXHR, textStatus, error)
        options.error?(jqXHR, textStatus, error)

  handle_ajax_error: (jqXHR, textStatus, error) ->
    console.log("Something went wrong: " + textStatus)
    if textStatus == 'timeout'
      r = confirm "Your internet connection seems to be slow. The ETM is
      still waiting to receive an update from the server. Press OK to reload
      the page"
      location.reload(true) if (r)

  handle_api_result: ({results, settings, inputs}, data, textStatus, jqXHR) =>
    # store the last response from api for the turk it debugging tool
    # it is activated by passing ?debug=1 and can be found in the settings
    # menu.
    $("#last_api_response").val(jqXHR.responseText)
    for own key, values of results
      if gquery = window.gqueries.with_key(key)
        gquery.handle_api_result(values)

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
    dirtyInputElements = @input_elements.dirty()
    return if dirtyInputElements.length == 0
    input_params = @input_elements.api_update_params()
    @input_elements.reset_dirty()
    @call_api(input_params)

  showLoading: ->
    # D3 charts shouldn't be blocked, only jqPlot ones
    $(".chart_holder[data-block_ui_on_refresh=true]:visible").busyBox
      spinner: "<em>Loading</em>"
    $("#dashboard .loading").show()
    $(".arrow").css("opacity", "0.0")

  hideLoading: ->
    $(".chart_holder").busyBox('close')
    $("#dashboard .loading").hide()

  debug: (t) ->
    console.log(t) if globals.debug_js

  disabledSettings: ->
    '#settings_menu a.save,
     #settings_menu a#reset_scenario'

  disableIdDependantSettings: =>
    $(@disabledSettings()).
      addClass('wait').on('click', disabledSetting)

  enableIdDependantSettings: (args...) =>
    $(@disabledSettings())
      .removeClass('wait').off('click', disabledSetting)

  # TODO: Move this interface methods to a separate Interface class
  #
  update_merit_order_checkbox: =>
    $(".merit-data-downloads").toggle(@settings.merit_order_enabled())
    $("#settings_use_merit_order").attr('checked', @settings.merit_order_enabled())
