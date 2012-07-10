class @BaseChartView extends Backbone.View
  events:
    "click a.default_chart": "load_default"

  initialize_defaults: =>
    @model.bind('change', @render_as_needed)

  render_as_needed: =>
    if @display_as_table && @can_be_shown_as_table()
      @render_as_table()
    else
      @render()

  max_value: ->
    sum_present = _.reduce @model.values_present(), @smart_sum
    sum_future = _.reduce @model.values_future(), @smart_sum
    target_results = _.flatten(@model.target_results())
    max_value = _.max($.merge([sum_present, sum_future], target_results))

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

  update_title: ->
    @$el.find('h3').html(@model.get("name"))
    @$el.data('chart_id', @model.get('id'))
    @$el.attr('data-block_ui_on_refresh', @block_ui_on_refresh())
    @$el.find('a.chart_info').toggle(@model.get('has_description'))

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
    @display_as_table = !@display_as_table
    @render_as_needed()
    @$el.find("a.table_format").toggle(!@display_as_table)
    @$el.find("a.chart_format").toggle(@display_as_table)

  hide_format_toggler: => $("a.toggle_chart_format").hide()

  can_be_shown_as_table: -> true
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

  load_default: -> charts.load_default()

  # D3 charts override this method
  supported_in_current_browser: -> true

  # Override as needed
  height: => 300
