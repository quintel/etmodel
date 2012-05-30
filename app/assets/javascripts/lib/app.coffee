window.loading = $("#content").busyBox
  spinner: '<img src="/assets/layout/ajax-loader.gif" />'

_.extend(_, {
  sum: (arr) =>
    _.reduce(arr, ((sum, v) -> sum + v), 0)
})

class @AppView extends Backbone.View
  initialize: ->
    # this at the moment used for the loading box. to figure out
    # if there are still api calls happening.
    @api_call_stack = []

    # Jaap MVC legacy
    @input_elements = window.input_elements
    @input_elements.bind("change", @handleInputElementsUpdate)

    @settings = new Setting() # At this point settings is empty!!
    @settings.set({'api_session_id' : globals.api_session_id})
    @scenario = new Scenario()
    # initialize later in bootstrap, because we need to know what country it is
    @peak_load = null

  # At this point we have all the settings initialized.
  bootstrap: =>
    dashChangeEl = $('#dashboard_change')

    window.sidebar.bootstrap()
    # If a "change dashboard" button is present, set up the DashboardChanger.
    if dashChangeEl.length > 0
      new DashboardChangerView(dashChangeEl)
    @setup_fce()

    # DEBT Add check, so that boostrap is only called once.
    if @settings.get('area_code') == 'nl'
      @peak_load = new PeakLoad()
    if @scenario.api_session_id() == null
      @scenario.new_session()
      # after completing new_session() App.bootstrap is called again and will
      # thus continue the else part
    else
      @load_user_values()
      @call_api()

  setup_fce: =>
    @update_fce_checkboxes()
    # IE doesn't bubble onChange until the checkbox loses focus
    $(document).on 'click', ".inline_use_fce, #settings_use_fce", @settings.toggle_fce

  update_fce_checkboxes: ->
    # update the use_fce checkbox inside descriptions as needed on page load
    $(".inline_use_fce").attr('checked', @settings.get('use_fce'))

  # Load User values for Sliders
  load_user_values: => @input_elements.load_user_values()

  ensure_scenario_id: =>
    if @scenario.api_session_id() == null
      console.log("No scenario!")
      @scenario.new_session()

  call_api: (input_params) =>
    return false unless @scenario.api_session_id()
    url = @scenario.query_url(input_params)
    keys = window.gqueries.keys()
    keys_ids = _.select(keys, (key) -> !key.match(/\(/))
    keys_string = _.select(keys, (key) -> key.match(/\(/))
    params =
      'r' : keys_ids.join(';')
      'result' : keys_string
      'use_fce' : App.settings.get('use_fce')

    @showLoading()
    $.ajaxQueue
      url: url
      data: params
      type: 'PUT'
      success: @handle_api_result
      error: (xOptions, textStatus) =>
        console.log("Something went wrong: " + textStatus)
        @handle_timeout() if textStatus == 'timeout'
        @hideLoading()
      timeout: 10000
    @register_api_call('call_api')

  handle_timeout: ->
    r = confirm "Your internet connection seems to be very slow. The ETM is
      still waiting to receive an update from the server. Press OK to reload
      the page"
    location.reload(true) if (r)

  has_unfinished_api_calls: => _.isEmpty(@api_call_stack)

  register_api_call: (api_call) => @api_call_stack.push(api_call)

  unregister_api_call: (api_call) =>
    @api_call_stack = _.without(@api_call_stack, api_call)

  # The following method could need some refactoring
  # e.g. el.set({ api_result : value_arr })
  # window.charts.first().trigger('change')
  # window.dashboard.trigger('change')
  handle_api_result: (data) ->
    App.unregister_api_call('call_api')
    loading.fadeIn('fast') #show loading overlay
    for own key, values of data.result
      gqueries = window.gqueries.with_key(key)
      for g in gqueries
        g.handle_api_result(values)
    window.charts.invoke 'trigger', 'change'
    if window.targets
      window.targets.invoke('update_view')
      window.targets.update_totals()
      window.targets.update_total_score()
    window.sidebar.update_bars()

    if App.settings.get('track_peak_load') && App.peak_load
      App.peak_load.trigger('change')

    $("body").trigger("dashboardUpdate")
    App.hideLoading()

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
  doUpdateRequest: ->
    dirtyInputElements = window.input_elements.dirty()
    return if dirtyInputElements.length == 0
    input_params = window.input_elements.api_update_params()
    window.input_elements.reset_dirty()
    window.App.call_api(input_params)

  # Shows a busy box. Only if api_call_stack is empty. Make sure
  # that you call the showLoading before adding the jsonp to api_call_stack.
  showLoading: =>
    if @has_unfinished_api_calls()
      if charts.current().get('type') != 'd3'
        $("#charts_wrapper").busyBox({
          spinner: '<img src="/assets/layout/ajax-loader.gif" />'
        }).fadeIn('fast')

      $("#constraints").busyBox({
        classes: 'busybox ontop'
        spinner: '<img src="/assets/layout/ajax-loader.gif" />'
        top:     '22px'
      }).fadeIn('fast')

      # BusyBox doesn't account for elements which have position: fixed when the
      # user has scrolled the window.
      $.fn.busyBox.container.find('.busybox').each ->
        element = $(this)
        if element.css('position') == 'fixed'
          top = parseInt(element.css('top').match(/^\d+/)[0])
          element.css('top', top - $(window).scrollTop())

  # Closes the loading box. will only close if there's no api_calls
  # running at the moment
  hideLoading: =>
    if @has_unfinished_api_calls()
      $("#charts_wrapper").busyBox('close')
      $("#constraints").busyBox('close')

  etm_debug: (t) -> console.log(t) if window.etm_js_debug

  # Use CORS when possible
  api_base_url: ->
    if !globals.disable_cors && Browser.hasProperCORSSupport()
      globals.api_url
    else
      globals.api_proxy_url

window.App = App = new AppView()
