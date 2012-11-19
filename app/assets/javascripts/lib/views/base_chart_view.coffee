class @BaseChartView extends Backbone.View
  initialize_defaults: =>
    @model.bind('change', @render_as_needed)

  render_as_needed: =>
    if @model.get('as_table') && @can_be_shown_as_table()
      @render_as_table()
    else
      @render()

  max_value: -> _.max @model.values()

  smart_sum: (sum, x) ->
    y = if x > 0 then x else 0
    sum + y

  # used when drawing the tick options on some chart types
  significant_digits: =>
    max = @max_value() / Math.pow(1000, @data_scale())
    return 0 if max >= 100
    return 1 if max >= 10
    return 2

  parsed_unit: ->
    unit = @model.get('unit')
    Metric.scale_unit(@max_value(), unit)

  # returns the power of thousand of the largest value shown in the chart
  # this is used to scale the values around the chart
  data_scale: -> Metric.power_of_thousand @max_value()

  container_id: -> @model.get("container")

  # This is the dom element that will be filled with the chart. jqPlot expects
  # an id
  container_node : -> $ "##{@container_id()}"

  clear_container: -> @container_node().empty()

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
    @$el.find("a.chart_format, a.table_format").hide()
    if @model.can_be_shown_as_table()
      if @model.get 'as_table'
        @$el.find("a.chart_format").show()
      else
        @$el.find("a.table_format").show()
    @$el.find(".chart_not_finished").toggle @model.get("under_construction")
    @$el.find("a.default_chart").toggle @model.wants_default_button()
    @update_lock_icon()
    this

  update_lock_icon: =>
    icon = @$el.find('a.lock_chart')
    if @model.get 'locked'
      icon.removeClass('icon-unlock').addClass('icon-lock')
    else
      icon.removeClass('icon-lock').addClass('icon-unlock')

  create_legend: (opts) ->
    renderer: $.jqplot.EnhancedLegendRenderer
    show: true
    location: opts.location || 's'
    fontSize: @defaults.font_size
    placement: "outside"
    labels: opts.labels || @model.labels()
    yoffset: opts.offset || 25
    rendererOptions:
       numberColumns: opts.num_columns
       seriesToggle: false

  defaults:
    shadow: false
    font_size: '11px'
    grid:
      drawGridLines: false     # wether to draw lines across the grid or not.
      gridLineColor: '#cccccc' # Color of the grid lines.
      background: '#ffffff'    # CSS color spec for background color of grid.
      borderColor: '#cccccc'   # CSS color spec for border around grid.
      borderWidth: 0.0         # pixel width of border around grid.
      shadow: false            # draw a shadow for grid.
    stacked_line_axis_default:
      tickOptions:
        formatString: '%d'
        fontSize: '11px'
    highlighter:
      show: false

  toggle_format: =>
    tbl = @model.get 'as_table'
    @render_as_needed()
    @$el.find("a.table_format").toggle(!tbl)
    @$el.find("a.chart_format").toggle(tbl)

  hide_format_toggler: => $("a.toggle_chart_format").hide()

  # Derived classes can override this
  #
  can_be_shown_as_table: -> true

  # D3 charts set this to false because they support animations. jqplot charts
  # don't, so while waiting for the data the chart container is blocked by a
  # busybox
  #
  block_ui_on_refresh: -> true

  render_as_table: =>
    @clear_container()
    table_data =
      start_year: App.settings.get('start_year')
      end_year: App.settings.get('end_year')
      series: @model.formatted_series_hash()
    tmpl = $("#chart-table-template").html()
    table = _.template(tmpl, table_data)
    @container_node().html(table)

  # D3 charts override this method
  supported_in_current_browser: -> true

  # Override as needed
  height: => 300
