class @ChartList extends Backbone.Collection
  model : Chart

  initialize: ->
    $.jqplot.config.enablePlugins = true
    @container = $("#charts_wrapper")
    @template = _.template $('#chart-holder-template').html()

    # We can have multiple charts. This hash keeps track ok which chart holders
    # are being used
    @chart_holders = {}

    @setup_callbacks()

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
  #             ignore_lock - don't overwrite the lock flag. This might be
  #                           needed on the initial render, where we want to
  #                           plot the charts and preserve the locks
  #             wait        - don't fire the API request immediately
  #             wrapper     - selector for the wrapper that will contain the
  #                           chart holder
  #             prunable    - if true then the chart should be garbage
  #                           collected using the collection's prune() method.
  #                           Zoomed-in and dashboard charts use this option
  #
  # Returns the newly created chart object or false if something went wrong
  load: (chart_id, holder_id = null, options = {}) =>
    if @should_load_chart(chart_id, holder_id, options)
      App.debug """Loading chart: ##{chart_id} in #{holder_id}
                 #{window.location.origin}/admin/output_elements/#{chart_id}"""

      @chart_requests.push(@request_output_element(chart_id, holder_id, options))

      @last()

  should_load_chart: (chart_id, holder_id = null, options = {}) =>
    should_load = true
    current     = @chart_in_holder(holder_id)

    if current && current.get('chart_id') == chart_id && !options.force
      should_load = false

    # if we want to replace a locked chart...
    locked_charts = App.settings.get 'locked_charts'

    if locked_charts[holder_id]
      if options.force
        # TODO: Remove the toggle_lock method because this method should return
        # a boolean but now also excecutes code in between which is confusing.
        current.toggle_lock(false)
      else if !options.ignore_lock
        should_load = false

    should_load

  request_output_element: (chart_id, holder_id = null, options = {}) =>
    $.ajax
      url: "/output_elements/#{ chart_id }"
      error: (jqXHR) ->
        if jqXHR.status == 404
          s = App.settings.get 'locked_charts'
          delete s[holder_id]
          App.settings.save locked_charts: s

      success: (data) =>
        holder_id = @add_container_if_needed(holder_id, options)

        # Create the new Chart. The id attribute is concatenated to the
        # holder_id because backbone collections make items unique by id. We
        # want to be able to show the same chart more than once
        #
        settings = _.extend {}, data.attributes, {
            id: "#{ data.attributes.id }-#{ holder_id }"
            chart_id: data.attributes.id
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

        # Render the chart only if it is not new chart
        if options.ignore_lock == undefined
          @add new_chart
          App.call_api() unless options.wait

  # Returns the chart held in a holder
  #
  chart_in_holder: (holder_id) => @chart_holders[holder_id]

  # restores the default chart for the current slide
  #
  load_default: =>
    @chart_in_holder('holder_0').toggle_lock(false)
    @load @default_chart_id, 'holder_0'

  # This is called right after the app bootstrap. And renders the default
  # chart and the other optional locked charts.
  # There is some (ugly) logic to keep track of which charts should have the
  # locked flag on and which not
  #
  load_charts: (custom_charts) =>
    # The accordion takes care of setting @default_chart_id
    @chart_requests = []

    settings = custom_charts || App.settings.get('locked_charts')

    # safe copy of the settings hash
    charts_to_load = _.extend {}, settings

    # is the default chart locked?
    unless default_chart_locked = settings.holder_0
      # if not then use the default chart
      if @default_chart_id
        charts_to_load.holder_0 = @default_chart_id

    ordered_charts = _.keys(charts_to_load).sort()

    for holder in ordered_charts
      chart = charts_to_load[holder]
      # The chart string has this format:
      #     XXX-YYY
      # XXX is the chart id, while YYY is 'T' if the chart must be shown as
      # a table.
      # Historical note: this "chart string" used to be a nested hash, but it
      # turned out to be very painful to handle. This is why ETM uses
      # active-record sessions, too: hashes weren't saved properly in
      # memcached/dalli stores. Weird active support bug that I've not
      # bothered fixing since Rails 4 rewrites most of it.
      # PZ
      [id, format] = "#{chart}".split '-'

      locked = if (holder != 'holder_0')
        true
      else
        default_chart_locked

      if id && holder
        @load(id, holder, {
          locked: locked,
          as_table: (format == 'T'),
          # the initial render should ignore the lock check: render the charts
          # but don't remove the locks, which is what `force: true` would do
          ignore_lock: true
        })

    # The @chart_requests are jqXHR objects returned by $.ajax().
    # Here, we want to wait until all Ajax requests have returned, no matter
    # their success, but $.when has a fast-failure feature if one
    # of the requests fails.
    # Hence, we have to wrap the jqXHRs in new Deferreds which will
    # always return successfully - after all, we are not interested in the
    # success of the requests anyways (since success is handled directly in
    # callbacks to the Ajax calls).
    $.when.apply(null, @chart_requests.map((request) ->
      deferred = $.Deferred()
      request.always ->
        deferred.resolve()
      deferred
    )).always( =>
      App.call_api()

      for holder_id, chart of @chart_holders
        @add chart
    )

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
      chart.delete()
      @remove chart

  # returns the chart itself or false
  #
  chart_already_on_screen: (chart_id) =>
    for holder, chart of @chart_holders
      return chart if chart.id == chart_id
    false

  # This stuff could be handled by a Backbone view, but a document-scoped
  # event binding prevents memory/event leaks and will be called just once.
  #
  setup_callbacks: ->
    load_chart = @load

    # Launch the chart picker popup
    #
    $(document).on "touchend click", "a.select_chart, a.add_chart", (e) ->
      e.preventDefault()
      url = $(this).attr('href')
      $.fancybox.open
        autoSize: false
        href: url
        type: 'ajax'
        width: 930
        height: 700
        padding: 0
        afterShow: ->
          # Pick a chart from the chart picker popup
          #
          # $('body').on "click touchdown", "div.pick_chart", (e) =>
          $('#select_charts .pick_chart').on 'touchend click', (e) =>
            data_holder = $(e.target).closest('div.pick_chart')
            holder_id = data_holder.data('chart_holder')
            chart_id  = data_holder.data('chart_id')
            console.log("Loading: #{ chart_id }")
            load_chart chart_id, holder_id, force: true
            close_fancybox()
            e.preventDefault()

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

    # Zoom chart
    #
    $(document).on 'touchend click', 'a.zoom_chart', (e) =>
      e.preventDefault()
      holder_id = $(e.target).parents(".chart_holder").data('holder_id')
      chart = @chart_in_holder holder_id
      if chart.get('type') == 'block'
        alert("Sorry, this chart can't be zoomed")
        return false
      format = if chart.get('as_table') == true then 'table' else 'chart'
      url = "#{$(e.target).attr('href')}?format=#{format}"
      $.fancybox.open
        autoSize: false
        href: url
        type: 'ajax'
        width: 1100
        height: 570
        padding: 0
        beforeClose: ->
          # don't leave stale charts around!
          charts.prune()
