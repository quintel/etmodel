class @BaseChartView extends Backbone.View
  initialize_defaults: ->
    @model.bind('change', this.render)

  clear_container: ->
    @container_node().empty()

  max_value: ->
    sum_present = _.reduce @model.values_present(), (sum, v) -> return sum + (v > 0 ? v : 0)
    sum_future = _.reduce @model.values_future(), (sum, v) -> return sum + (v > 0 ? v : 0)
    target_results = _.flatten(@model.target_results())
    max_value = _.max($.merge([sum_present, sum_future], target_results))

  parsed_unit: ->
    unit = @model.get('unit')
    Metric.scale_unit(@max_value(), unit)

  # returns the power of thousand of the largest value shown in the chart
  # this is used to scale the values around the chart
  data_scale: ->
    Metric.power_of_thousand @max_value()

  container_id: ->
    @model.get("container")

  container_node : ->
    $("##{@container_id()}")

  title_node : ->
    $("#charts_holder h3")

  update_title: ->
    @title_node().html(@model.get("name"))

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

  toggle_format: ->
    @display_as_table = !@display_as_table
    console.log @display_as_table
    if @can_be_shown_as_table() && @display_as_table
      @render_as_table()
    else
      @render()

  can_be_shown_as_table: -> true

  render_as_table: =>
    console.log "Hi! I'm a table"
    @clear_container()
    console.log @model.series_hash()
