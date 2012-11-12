class @ChartList extends Backbone.Collection
  model : Chart

  initialize: ->
    $.jqplot.config.enablePlugins = true
    @setup_callbacks()

  # table and cost charts are HTML-based. Their HTML is returned by the Rails app
  # and the Backbone app takes care of inserting it into the DOM adding
  # the gqueries result values. This hash stores the HTML for the charts
  # using the chart_id as key.
  html: {}

  # We can have multiple charts. This hash keeps track ok which chart holders
  # are being used
  chart_holders: {}

  # Loads a chart into a DOM element making an AJAX request
  #
  # chart_id  - id of the chart
  # holder_id - id of the dom element that will hold the chart (default: 'chart_0')
  # options   - hash with some options (default: {})
  #             alternate - id of the chart to load if the first one fails.
  #                         Watch out for loops!
  #             force     - (re)load the chart entirely
  #
  # Returns the newly created chart object or false if something went wrong
  load: (chart_id, holder_id = 'chart_0', options = {}) =>
    if !options.force && (@pinned_chart_in(holder_id) || @current_chart_in(holder_id) == chart_id)
      return false

    alternate = options.alternate || false

    App.debug('Loading chart: #' + chart_id)
    App.debug "#{window.location.origin}/admin/output_elements/#{chart_id}"
    url = "/output_elements/#{chart_id}"
    $.ajax
      url: url
      success: (data) =>

        # Create the new Chart
        new_chart = new Chart(_.extend data.attributes, {
            container: holder_id
            html: data.html # tables and block chart
          })
        if !new_chart.supported_by_current_browser()
          if alternate
            @load alternate, holder_id
          else
            alert I18n.t('output_elements.common.old_browser')
          return false

        # Remember what we were showing in that position
        if old_chart = @chart_holders[holder_id]
          old_chart.delete()
          @remove old_chart

        @chart_holders[holder_id] = new_chart
        @add new_chart
        # Pass the gqueries to the chart
        for s in data.series
          s.owner = holder_id
          new_chart.series.add(s)

        # if the chart was pinned as table let's set the instance variable
        try
          show_as_table = App.settings.get('charts')[holder_id].format == 'table'
          new_chart.view.display_as_table = show_as_table
        catch e
          null

        new_chart.update_buttons()
        App.call_api()
    @last()

  # returns the current chart id
  current_id : => @current().get('id') if @current()

  # returns the main chart
  current: -> @chart_holders['main_chart']

  # ugly
  remove_pin: (holder_id) =>
    chart_settings = App.settings.get('charts')
    chart_settings[holder_id].chart_id = false
    chart_settings[holder_id].format = null
    App.settings.save({charts: chart_settings})
    holder = $('#' + holder_id).parents('.chart_holder')
    holder.find("a.pin_chart").removeClass("icon-lock").addClass("icon-unlock")

  # returns the id of the chart pinned in a holder - or null
  pinned_chart_in: (holder_id) =>
    try
      App.settings.get('charts')[holder_id].chart_id
    catch e
      null

  # returns the id of the chart currently shown in a holder
  current_chart_in: (holder_id) =>
    try
      @chart_holders[holder_id].get 'id'
    catch e
      null

  # The default is defined for the main chart only
  load_default: =>
    @remove_pin 'chart_0'
    @load(App.settings.get('charts').chart_0.default)

  # This is called right after the app bootstrap. The rails app takes care of
  # filling the chart_canvas attributes
  load_pinned_charts: =>
    for c in $(".chart_canvas")
      chart_id = $(c).data('pinned_chart')
      if chart_id
        # the force parameter makes the loader skip the pinned charts check,
        # since this is the first time it is drawn
        @load chart_id, $(c).attr('id'), {force: true}

  # TODO: Most of this stuff should be moved to a backbone view. Unfortunately
  # there are some issues with the event bindings leaving zombies around:
  # http://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/
  setup_callbacks: ->
    # chart selection pop-up. Drops pinned chart for that holder and resets the
    # chart format
    $(document).on "click", "a.pick_charts", (e) =>
      holder_id = $(e.target).parents('a').data('chart_holder')
      chart_id = $(e.target).parents('a').data('chart_id')
      @remove_pin holder_id
      @load chart_id, holder_id
      close_fancybox()

    $(document).on 'click', "a.pin_chart", (e) =>
      e.preventDefault()
      # which chart are we talking about?
      holder_id = $(e.target).parents(".chart_holder").data('holder_id')
      chart = @chart_holders[holder_id]
      if @pinned_chart_in(holder_id)
        chart.unlock()
      else
        chart.lock()

    # link to open the secondary chart
    # The busybox setup will open the chart selection popup (see fancybox.coffee)
    $(document).on 'click', 'a.add_chart', (e) =>
      e.preventDefault()
      target = $(e.target).data('target')
      # Just show the chart holder
      $(".chart_holder[data-holder_id=#{target}]").removeClass('.hidden').show()
      $(e.target).remove()

    $(document).on 'click', 'a.remove_chart', (e) =>
      e.preventDefault()
      holder_id = $(e.target).parents(".chart_holder").data('holder_id')
      $(".chart_holder[data-holder_id=#{holder_id}]").hide()
      @remove_pin holder_id
      chart = @chart_holders[holder_id]
      if chart
        chart.delete()
        @remove chart

    $(document).on 'click', 'a.table_format, a.chart_format', (e) =>
      e.preventDefault()
      holder_id = $(e.target).parents(".chart_holder").data('holder_id')
      @chart_holders[holder_id].view.toggle_format()

