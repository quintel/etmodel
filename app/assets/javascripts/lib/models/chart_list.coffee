class @ChartList extends Backbone.Collection
  model : Chart

  # Sort in the order by which they appear in the UI.
  comparator: (model) ->
    parseInt(model.get('container').split('_')[1], 10)

  initialize: ->
    $.jqplot.config.enablePlugins = true
    @container = $("#charts_wrapper")
    @template = _.template $('#chart-holder-template').html()

    @default_holder = _.uniqueId('holder_')

    # We can have multiple charts. This hash keeps track ok which chart holders
    # are being used
    @chart_holders = {}

    @setup_callbacks()

  # Returns the first available holder or null if there is none.
  available_holder: =>
    if !@models.length && !App.settings.get('locked_charts').length
      # Initial page load and there are no locked charts: we need to return the
      # default holder so that the default chart can be shown.
      return @default_holder

    unlocked = @where(locked: false)[0]
    unlocked && unlocked.get('container') || null

  # Loads a chart into a DOM element making an AJAX request. Will create the
  # container if needed
  #
  # chart_id  - id of the chart
  # holder_id - id of the dom element that will hold the chart. If null then a
  #             new chart holder will be created
  # options   - hash with some options (default: {})
  #             alternate   - id of the chart to load if the first one fails.
  #                           Watch out for loops!
  #             force       - (re)load the chart entirely
  #             header      - show or hide the chart header (default: true)
  #             locked      - flag the chart as locked (default: false)
  #             as_table    - render the chart as a table (default: false). Only
  #                           some chart types have this feature!
  #             wait        - don't fire the API request immediately
  #             wrapper     - selector for the wrapper that will contain the
  #                           chart holder
  #             prunable    - if true then the chart should be garbage
  #                           collected using the collection's prune() method.
  #                           Zoomed-in and dashboard charts use this option
  #
  # Returns the newly created chart object or false if something went wrong
  load: (chart_id, holder_id = null, options = {}) =>
    # "load" is called when the page first loads; at this point the list of
    # chart models is not ready. Therefore we go to the app settings instead.
    locked_charts = App.settings.get('locked_charts').map(
      (id) -> id.split('-')[0]
    )

    # Will only have values when loading new charts (i.e. not on initial page
    # load).
    locked_holders = @where(locked: true).map((chart) -> chart.get('container'))

    will_replace_locked =
      # Is replacing an existing chart in an holder which is currently locked...
      _.contains(locked_holders, holder_id) ||
      # Is probably loading a second instance of a chart (zoomed, or in the
      # dashboard).
      _.contains(locked_charts, chart_id) ||
      # Trying to load a chart in the same holder in which is already appears?
      @chart_in_holder(holder_id)?.get('chart_id') == chart_id

    # Chart or holder is already present. Without a force option, return and
    # ignore the request to load the chart. This may happen by code trying to
    # load the default chart for a slide, when all available holders are locked.
    if will_replace_locked && !options.force
      return false

    App.debug(
      "Loading chart: ##{ chart_id } in #{ holder_id } | " +
      "#{ window.location.origin }/admin/output_elements/#{ chart_id }"
    )

    # If an old chart is already present in the holder, replace it with a
    # loading message.
    if holder_id && (existing_chart = @chart_in_holder(holder_id))
      existing_chart.trigger('willReplace')

    $.ajax(url: "/output_elements/#{ chart_id }")
      .fail (jqXHR) ->
          if jqXHR.status == 404
            s = App.settings.get 'locked_charts'
            delete s[holder_id]
            App.settings.save locked_charts: s
      .done (data) =>
        @render_output_element(chart_id, holder_id, options, data)

  # Loads the chart into the first available holder. If no holder is available
  # (i.e. all are locked), the chart will not be loaded.
  load_into_available_holder: (chart_id, options = {}) =>
    if !(holder_id = @available_holder())
      # No unlocked holders available into which this chart may be rendered.
      return false

    @load(chart_id, holder_id, options)

  render_output_element: (chart_id, holder_id, options, data) =>
    holder_id = @add_container_if_needed(holder_id, options)

    # Create the new Chart. The id attribute is concatenated to the
    # holder_id because backbone collections make items unique by id. We
    # want to be able to show the same chart more than once
    #
    settings = _.extend {}, data.attributes, {
      id: "#{ data.attributes.key }-#{ holder_id }"
      chart_id: data.attributes.key
      container: holder_id
      html: data.html # tables and block chart
      locked: options.locked
      as_table: options.as_table
      prunable: options.prunable
    }
    new_chart = new Chart settings

    if !new_chart.supported_by_current_browser()
      # try opening the alternative, but watch out for loops!
      if options.alternate && options.alternate != chart_id
        @load options.alternate, holder_id
      else
        # sorry, no chart to load...
        alert I18n.t('output_elements.common.old_browser')
        # delete holder if empty
        @delete_container(holder_id) unless @chart_holders[holder_id]
      return false

    if old_chart = @chart_in_holder holder_id
      old_chart.delete()
      @remove old_chart

    # Remember what we were showing in that position
    @chart_holders[holder_id] = new_chart

    # Pass the gqueries to the chart
    for s in data.series
      s.owner = holder_id
      new_chart.series.add(s)

    @add(new_chart)

    App.analytics.chartAdded(data.attributes.key)
    App.call_api() unless options.wait

  # Returns the chart held in a holder
  #
  chart_in_holder: (holder_id) => @chart_holders[holder_id]

  # restores the default chart for the current slide
  #
  load_default: =>
    @chart_in_holder(@default_holder).toggle_lock(false)
    @load @default_chart_id, @default_holder

  load_related: (holder, related_chart_id) =>
    @chart_in_holder(holder).toggle_lock(false)
    @load related_chart_id, holder

  # With the list of locked charts (formatted as their ID and display format,
  # e.g. "190-C"), renders each chart in a unique holder. Used when the page is
  # first loaded.
  #
  # If the visitor has no locked charts, the default is loaded instead.
  load_initial_charts: (wanted) =>
    if !wanted.length && @default_chart_id
      @load_charts([{ id: @default_chart_id, holder: @default_holder }])
    else if wanted.length
      @load_charts(wanted.map((chart, index) =>
        [id, format] = chart.split('-')

        as_table = format == 'T'
        holder = index == 0 && @default_holder || _.uniqueId('holder_')

        { id, as_table, holder }
      ))

  # Loads one or more charts, based on options given.
  #
  # `charts` should be an array of objects containing the chart `id`, the
  # `holder` (DOM element ID) into which it should be rendered, and any
  # additional options.
  #
  # For example
  #
  #   list.load_charts([
  #     { id: 190, as_table: false, holder: 'holder_80'},
  #     { id: 64, as_table: true, holder: 'holder_81'}
  #   ])
  #
  # A second parameter accepts options which are passed transparently to
  # Api.call_api when fetching the chart data.
  #
  # charts     - An array of objects containing information which which charts
  #              should be rendered.
  # apiOptions - Options passed to Api.call_api when feching chart data.
  #
  # Returns nothing.
  load_charts: (charts, apiOptions = {}) =>
    render_options = {}
    request_ids    = []

    for chart, index in charts
      render_options[chart.id] = {
        holder: chart.holder,
        locked: if chart.locked? then chart.locked else true,
        as_table: chart.as_table,
        wait: true,
        force: true # the initial render should ignore the lock check
      }

      request_ids.push(chart.id)

    return $.Deferred().resolveWith({}) unless request_ids.length

    $.ajax(url: "/output_elements/batch/#{ request_ids.join(',') }")
      .fail (jqXHR) ->
        console.error('Failed to fetch output elements')
      .done (data) =>
        for id in request_ids when data[id]
          @render_output_element(
            id,
            render_options[id].holder,
            render_options[id],
            data[id]
          )

        App.call_api({}, apiOptions)

    null # Return nothing.

  # adds a chart container, unless it is already in the DOM. Returns the
  # holder_id
  #
  # holder_id - id of the container to add. If null it will be generated
  # options   - hash of optional parameters
  #             header    - boolean to show or hide the header bar. Usually
  #                         passed by the load() method above. Dashboard
  #                         popups set it to false, regular charts to true
  #             wrapper   - the DOM element where the container will be
  #                         appended. The default is '#charts_wrapper'
  #
  add_container_if_needed: (holder_id = null, options = {}) =>
    if !holder_id
      timestamp = (new Date()).getTime()
      holder_id = "holder_#{timestamp}"

    $container = if options.wrapper
      $(options.wrapper)
    else
      @container

    if $container.find("##{holder_id}").length == 0
      new_chart = @template(
        title: 'Loading'
        chart_id: 0
        holder_id: holder_id
        header: options.header,
        popup: options.popup)
      $container.append new_chart
    holder_id

  # This might be called if the chart loading fails and we don't want to leave
  # an empty holder
  #
  delete_container: (holder_id) =>
    $(".chart_holder[data-holder_id=#{holder_id}]").remove()

  # Deleted all the prunable charts, ie the charts that are loaded through the
  # dashboard popups and that should be removed when the user closes the popup
  #
  prune: =>
    prunables = @where prunable: true

    for chart in prunables
      delete @chart_holders[chart.get('container')]
      chart.delete()
      @remove chart

  # returns the chart itself or false
  #
  chart_already_on_screen: (chart_id) =>
    for holder, chart of @chart_holders
      return chart if chart.get('key') == chart_id
    false

  # This stuff could be handled by a Backbone view, but a document-scoped
  # event binding prevents memory/event leaks and will be called just once.
  #
  setup_callbacks: ->
    load_chart = @load

    # Event binding for downloading CSV
    $(document).on 'touchend click', 'a.download_csv', (e) =>
      e.preventDefault()
      holder_id = $(e.target).closest('.chart_holder').data('holder_id')
      @download_csv(holder_id)

    # Launch the chart picker popup
    #
    $(document).on "touchend click", "a.select_chart, a.add_chart", (e) =>
      e.preventDefault()

      holderId = $(e.target).closest('.chart_holder').data('holder_id')
      isDisabled = @chart_already_on_screen

      ChartListView.fetchData().then((data) ->
        new ChartListView(data: data).render(
          (chartId) -> load_chart(chartId, holderId, force: true),
          (chartId) -> isDisabled(chartId)
        )
      )

    # Prefetch chart data when hovering chart selection buttons.
    $(document).on "mouseover", "a.select_chart, a.add_chart", (e) =>
      ChartListView.fetchData();

    # Toggle chart lock
    #
    $(document).on 'touchend click', "a.lock_chart", (e) =>
      e.preventDefault()
      # which chart are we talking about?
      holder_id = $(e.target).parents(".chart_holder").data('holder_id')
      if chart = @chart_in_holder(holder_id)
        chart.toggle_lock()

    # Remove chart
    #
    $(document).on 'touchend click', 'a.remove_chart', (e) =>
      e.preventDefault()
      holder_id = $(e.target).parents(".chart_holder").data('holder_id')
      $(".chart_holder[data-holder_id=#{holder_id}]").remove()
      if chart = @chart_in_holder holder_id
        chart.delete()
        @remove chart
        delete @chart_holders[holder_id]

    $(document).on 'touchend click', 'a.show_related', (e) =>
      e.preventDefault()

      holder_id = $(e.target).parents('.chart_holder').data('holder_id')

      if chart = @chart_in_holder holder_id
        chart.delete()

        @load_related(holder_id, chart.get('related_id')).success =>
          @chart_in_holder(holder_id)
            .set('previous_id', chart.get('chart_id'))

          $(e.target).parents('.chart_holder')
            .find('.actions .show_previous').show()

        @remove chart

    $(document).on 'touchend click', 'a.show_previous', (e) =>
      e.preventDefault()

      holder_id = $(e.target).parents('.chart_holder').data('holder_id')

      if chart = @chart_in_holder holder_id
        chart.delete()
        @load_related(holder_id, chart.get('previous_id'))
        @remove chart

    # Toggle chart/table format
    #
    $(document).on 'touchend click', 'a.table_format, a.chart_format', (e) =>
      e.preventDefault()

      holder_target = if $(e.target).parents(".fancybox-inner").length > 0
        $(e.target).parents(".fancybox-inner").find(".chart_holder")
      else
        $(e.target).parents(".chart_holder")

      holder_id = $(holder_target).data('holder_id')
      @chart_in_holder(holder_id).toggle_format()

    # Restore the default chart
    #
    $(document).on 'touchend click', 'a.default_chart', (e) =>
      e.preventDefault()
      @load_default()

    # Given a link to fetch chart information and an optional format, open the
    # chart in a FancyBox pop-up.
    zoomChart = (href, format) ->
      return $.fancybox.open({
        autoSize: false
        href: "#{href}?format=#{format || 'chart'}"
        type: 'ajax'
        width: 1100
        height: 570
        padding: 0
        beforeClose: ->
          # don't leave stale charts around!
          charts.prune()
      })

    # Zoom chart
    #
    $(document).on 'touchend click', 'a.zoom_chart', (e) =>
      e.preventDefault()
      holder_id = $(e.target).parents(".chart_holder").data('holder_id')
      chart = @chart_in_holder holder_id
      if chart.get('type') == 'block'
        alert("Sorry, this chart can't be zoomed")
        return false

      zoomChart(
        $(e.target).attr('href'),
        if chart.get('as_table') == true then 'table' else 'chart'
      )

    # Click chart link
    #
    $(document).on 'touchend click', 'a.open_chart', (e) =>
      e.preventDefault()

      target = $(e.target)

      if target.data('chart-location') == 'side'
        @load(target.data('chartKey')) unless @chart_already_on_screen(target.data('chartKey'))
      else
        url = [
          window.location.origin,
          'output_elements',
          target.data('chartKey'),
          'zoom'
        ]

        zoomChart(url.join('/'), target.data('chartFormat'))

  download_csv: (holder_id) ->
    chart = @chart_in_holder(holder_id)
    unless chart
      console.error('No chart found for holder_id:', holder_id)
      return
    table_data = chart.get_table_data()
    csv_content = @convert_to_csv(table_data)

    # Fetch the title from the DOM
    title = $("[data-holder_id='#{holder_id}'] h3").text()
    if !title
      title = 'Chart'
    safe_title = title.replace(/[<>:"/\\|?*]+/g, '') # Remove invalid filename characters
    filename = "#{safe_title}.csv"
    @trigger_csv_download(csv_content, filename)

  convert_to_csv: (data) ->
    csv = ''
    for row in data
      csv += row.join(',') + '\n'
    csv

  trigger_csv_download: (csv_content, filename) ->
    blob = new Blob([csv_content], { type: 'text/csv;charset=utf-8;' })
    link = document.createElement("a")
    url = URL.createObjectURL(blob)
    link.setAttribute("href", url)
    link.setAttribute("download", filename)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
