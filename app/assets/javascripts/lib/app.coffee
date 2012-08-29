_.extend(_, {
  sum: (arr) =>
    _.reduce(arr, ((sum, v) -> sum + v), 0)
})

class @AppView extends Backbone.View
  initialize: ->
    # this at the moment used for the loading box. to figure out
    # if there are still api calls happening.
    @api_call_stack = []

    @input_elements = new InputElementList()
    @input_elements.bind("change", @handleInputElementsUpdate)

    @settings = new Setting() # At this point settings is empty!!
    @settings.set({api_session_id: globals.api_session_id})

    @sidebar = new SidebarView()
    @scenario = new Scenario()

    @api = new ApiGateway
      scenario_id:   globals.api_session_id
      beforeLoading: @showLoading
      afterLoading:  @hideLoading

    # Store the scenario id
    @api.ensure_id().done (id) =>
      @settings.save
        api_session_id: id


  # At this point we have all the settings initialized.
  bootstrap: =>
    dashChangeEl = $('#dashboard_change')

    @sidebar.bootstrap()
    # If a "change dashboard" button is present, set up the DashboardChanger.
    if dashChangeEl.length > 0
      new DashboardChangerView(dashChangeEl)
    @setup_fce()

    # DEBT Add check, so that boostrap is only called once.
    if @settings.get('area_code') == 'nl'
      @peak_load = new PeakLoad()

    @load_user_values()
    @setup_fce_toggle()

  setup_fce_toggle: ->
    if element = $('.slide .fce-toggle')
      (new FCEToggle(el: element, model: App.settings)).render()

  reset_scenario: =>
    @settings.set({
      api_session_id: null,
      scenario_id: null,
      network_parts_affected: []
      }, {silent: true})
    @deferred_scenario_id = null
    i.set({user_value: null}, {silent: true}) for i in @input_elements.models
    @load_user_values()

  scenario_url: =>
    "#{globals.api_url.replace('api/v3', 'scenarios')}/#{@scenario.api_session_id()}"

  setup_fce: =>
    # IE doesn't bubble onChange until the checkbox loses focus
    $(document).on 'click', "#settings_use_fce", @settings.toggle_fce

  # Load User values for Sliders. We need a scenario id first!
  load_user_values: =>
    @api.user_values
      success: @input_elements.initialize_user_values
      error:   @handle_ajax_error

  call_api: (input_params) =>
    @api.update({
      queries: window.gqueries.keys(),
      inputs:  input_params,
      # callbacks
      success: @handle_api_result
      error:   @handle_ajax_error
    })

  handle_ajax_error: (jqXHR, textStatus, error) ->
    console.log("Something went wrong: " + textStatus)
    if textStatus == 'timeout'
      r = confirm "Your internet connection seems to be very slow. The ETM is
      still waiting to receive an update from the server. Press OK to reload
      the page"
      location.reload(true) if (r)

  # The following method could need some refactoring
  # e.g. el.set({ api_result : value_arr })
  # window.charts.first().trigger('change')
  # window.dashboard.trigger('change')
  handle_api_result: ({results, settings, inputs}, data, textStatus, jqXHR) =>
    @api_call_stack.pop()
    # store the last response from api for the turk it debugging tool
    # it is activated by passing ?debug=1 and can be found in the settings
    # menu.
    $("#last_api_response").val(jqXHR.responseText)
    for own key, values of results
      if gquery = window.gqueries.with_key(key)
        gquery.handle_api_result(values)

    window.charts.invoke 'trigger', 'change'
    if t = window.targets
      t.invoke('update_view')
      t.update_totals()
    @sidebar.update_bars()

    if App.settings.get('track_peak_load') && App.peak_load
      App.peak_load.trigger('change')

    $("body").trigger("dashboardUpdate")

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
    $("#constraints .loading").show()

  hideLoading: ->
    $(".chart_holder").busyBox('close')
    $("#constraints .loading").hide()

  debug: (t) ->
    console.log(t) if globals.debug_js

  # Use CORS when possible
  api_base_url: ->
    if !globals.disable_cors && Browser.hasProperCORSSupport()
      globals.api_url
    else
      globals.api_proxy_url

$ ->
  window.App = App = new AppView()
  App.settings.set(globals.settings, {silent : true});
  App.bootstrap()
  window.charts = new ChartList()
  charts.load_pinned_charts()
  acc = new Accordion()
  acc.setup()


