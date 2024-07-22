# All charts inherit from this base class.
#
class @BaseChartView extends Backbone.View
  # Customise the way the table-view is rendered. Possibilities are:
  #
  # labelFormatter: A function which should return a function; used to format
  #                 the label for each row.
  #
  # valueFormatter: A function which should return a function; used to format
  #                 the present and value in each row.
  #
  # sorter:         A function which should return a function; receives the
  #                 entire series, and should return the series sorted as
  #                 desired.
  #
  # For example:
  #
  #   tableOptions:
  #     labelFormatter: -> (serie)  -> serie.get('label')
  #     valueFormatter: -> (value)  -> Math.round(value)
  #     sorter:         -> (series) -> series.reverse()
  tableOptions: {}

  initialize_defaults: =>
    @model.bind('refresh', @render_as_needed)
    @model.bind('willReplace', @prepare_replace)
    @init_margins && @init_margins()

  # Triggered by the willReplace event; removes action buttons and shows a
  # loading block while a new chart is loaded.
  prepare_replace: =>
    loading_el = $('<div class="loading" />')
    canvas = @$el.find('.chart_canvas')

    if canvas.length > 0
      # Set the height of the loading element to be the same as the chart it
      # replaces to prevent a second/third/... chart from jumping up and down
      # the page. Don't bother if this is the only chart.
      if @model.collection.length > 1
        loading_el.css(height: canvas.height() - 1)
    else
      canvas = @$el.find('.table_canvas')

    canvas.empty().append(loading_el)

    @$el.find('header h3').text('Loading')
    @$el.find('.actions').hide()

    @model.set(will_replace: true)

  # Separate chart and table rendering
  render_as_needed: =>
    @update_header()
    @setup_holder_class()
    if @model.get('as_table') && @can_be_shown_as_table()
      @render_as_table()
    else
      @render()

  check_merit_enabled: =>
    unless App.settings.merit_order_enabled()
      @container_node().html(
        $('<div>').html(I18n.t('wells.warning.merit')).addClass('well')
      )

  # the chart_canvas class has a predefined height, while the table_canvas
  # expands to fit content
  setup_holder_class: =>
    if @model.get('as_table') || @model.get('type') == 'html_table'
      @container_node().removeClass('chart_canvas').addClass('table_canvas')
    else
      @container_node().addClass('chart_canvas').removeClass('table_canvas')

  max_value: -> _.max @model.values()

  container_id: -> @model.get("container")

  # This is the dom element that will be filled with the chart. jqPlot expects
  # an id
  container_node : -> $ "##{@container_id()}"

  clear_container: =>
    @container_node().empty()
    @drawn = false

  # updates the header items as needed, returns the videw itself to allow some
  # method chaining. Some of these updates should be moved to the underscore
  # templating
  #
  update_header: =>
    # Skip re-rendering if this chart is about to be replaced.
    return if @model.get('will_replace')

    id = @model.get 'chart_id'
    @$el.data('chart_id', id)
    @$el.find('h3').html(@model.get("name"))
    @$el.attr('data-block_ui_on_refresh', @block_ui_on_refresh())
    @$el.find('a.chart_info').toggle(@model.get('has_description'))
    @$el.find(".actions a.chart_info").attr "href", "/descriptions/charts/#{id}"
    @$el.find(".actions a.zoom_chart").attr "href", "/output_elements/#{id}/zoom"

    if @canDownloadImage()
      # saveAsPNG is exposed by app/javascripts/packs/app.ts
      #
      # Unbind any previously assigned saveAs event to prevent it being
      # triggered multiple times.
      @$el.find(".actions a.chart_to_image")
        .show()
        .off('click')
        .on('click', (event) -> BaseChartView.saveAsPNG(event, App.scenario.get('id')))
    else
      @$el.find(".actions a.chart_to_image").hide()

    @$el.find('.actions a').removeClass('loading')

    @format_wrapper = if @$el.parents(".fancybox-inner").length > 0
      @$el.parents(".fancybox-inner")
    else
      @$el

    @format_wrapper.find("a.chart_format, a.table_format").hide()
    @format_wrapper.find('a.download_csv').hide()
    if @model.can_be_shown_as_table()
      @format_wrapper.find("a.download_csv").show()
      if @model.get('as_table')
        @format_wrapper.find("a.chart_format").show()
      else
        @format_wrapper.find("a.table_format").show()

    @$el.find(".chart_not_finished").toggle @model.get("under_construction")
    @$el.find("a.default_chart").toggle @model.wants_default_button()
    @$el.find('a.show_related').toggle @model.wants_related_button()
    @$el.find('a.show_previous').toggle @model.wants_previous_button()

    @update_lock_icon()
    @$el.find('.actions').show()

    this

  canDownloadImage: ->
    if typeof Promise == 'undefined' then return false
    unless BaseChartView.saveAsPNG.isSupported then return false
    if this.supportsToImage == false then return false
    if this.model.get('config').supports_to_image == false then return false

    true

  update_lock_icon: =>
    icon = @$el.find('a.lock_chart')
    if @model.get 'locked'
      icon.removeClass('fa fa-unlock').addClass('fa fa-lock')
    else
      icon.removeClass('fa fa-lock').addClass('fa fa-unlock')

  toggle_format: =>
    tbl = @model.get 'as_table'
    @render_as_needed()
    @format_wrapper.find("a.table_format").toggle(!tbl)
    @format_wrapper.find("a.chart_format").toggle(tbl)

  hide_format_toggler: => $("a.toggle_chart_format").hide()

  # Internal: Returns a function which can format and scale values on an axis,
  # ensuring that all returned formatted values are in the same unit.
  create_scaler: (max_value, unit, opts = {}) ->
    if Quantity.isSupported(unit)
      Quantity.scaleAndFormatBy(max_value, unit, opts)
    else
      (value) -> Metric.autoscale_value(value, unit, opts.precision, opts.scaledown)

  # Internal: Returns a function which will format values for the "main" axis
  # of the chart.
  main_formatter: (opts = {}) =>
    maxValue = if opts.maxFrom is 'maxValue'
      @model.max_value()
    else
      max = @model.max_series_value()
      min = Math.abs(@model.min_series_value())

      if max > min then max else min

    unit = if opts.unit
      opts.unit
    else
      @model.get('unit')

    @create_scaler(maxValue, unit, opts)

  max_series_value: ->
    @model.max_series_value()

  # Derived classes can override this
  #
  can_be_shown_as_table: -> true

  # D3 charts set this to false because they support animations. jqplot charts
  # don't, so while waiting for the data the chart container is blocked by a
  # busybox
  #
  block_ui_on_refresh: -> true

  # Replaces the chart with a table. The CO2 Emissions chart overrides this
  # method because it has a different format
  #
  render_as_table: =>
    @clear_container()

    Table = @table_view_for()

    @container_node()
      .removeClass('chart_canvas')
      .addClass('table_canvas')
      .html(new Table(this, @tableOptions).render())

  table_view_for: ->
    switch @table_view()
      when 'merit_order_excess_table'
        MeritOrderExcessTableView
      when 'default'
        TableView

  table_view: -> 'default'

  # D3 charts override this method
  supported_in_current_browser: -> true
