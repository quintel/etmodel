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

  # Separate chart and table rendering
  render_as_needed: =>
    @setup_holder_class()
    if @model.get('as_table') && @can_be_shown_as_table()
      @render_as_table()
    else
      @render()

  check_merit_enabled: =>
    $(".merit-data-downloads").toggle(App.settings.merit_order_enabled())
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
    id = @model.get 'chart_id'
    @$el.data('chart_id', id)
    @$el.find('h3').html(@model.get("name"))
    @$el.attr('data-block_ui_on_refresh', @block_ui_on_refresh())
    @$el.find('a.chart_info').toggle(@model.get('has_description'))
    @$el.find(".actions a.chart_info").attr "href", "/descriptions/charts/#{id}"
    @$el.find(".actions a.zoom_chart").attr "href", "/output_elements/#{id}/zoom"

    @format_wrapper = if @$el.parents(".fancybox-inner").length > 0
      @$el.parents(".fancybox-inner")
    else
      @$el

    @format_wrapper.find("a.chart_format, a.table_format").hide()
    if @model.can_be_shown_as_table()
      if @model.get 'as_table'
        @format_wrapper.find("a.chart_format").show()
      else
        @format_wrapper.find("a.table_format").show()

    @$el.find(".chart_not_finished").toggle @model.get("under_construction")
    @$el.find("a.default_chart").toggle @model.wants_default_button()
    @update_lock_icon()
    this

  update_flexibility_order: (url, order) =>
    $.ajax
      url: url,
      type: 'POST',
      data:
        flexibility_order:
          order: order,
          scenario_id: App.scenario.api_session_id()
      success: ->
        App.call_api()
      error: (e,f) ->
        console.log('Throw error')

  set_sortable: =>
    self = this
    sortable_el = document.querySelectorAll("ul.sortable")[0]

    if sortable_el
      base_url = "#{ App.scenario.url_path() }/flexibility_order/"

      $.ajax
        url: "#{ base_url }get",
        type: 'GET',
        success: (data) ->
          Sortable.create sortable_el,
            ghostClass: 'ghost'
            animation: 150
            store:
              get: (sortable) ->
                data.order.concat(['curtailment'])

              set: (sortable) ->
                self.update_flexibility_order(
                  "#{ base_url }set",
                  sortable.toArray().concat(['curtailment'])
                )

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
      @model.max_series_value()

    @create_scaler(maxValue, @model.get('unit'), opts)

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

    @container_node()
      .removeClass('chart_canvas')
      .addClass('table_canvas')
      .html(new TableView(this, @tableOptions).render())

  # D3 charts override this method
  supported_in_current_browser: -> true
