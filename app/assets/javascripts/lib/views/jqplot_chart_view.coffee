# Old code that should be dropped when IE8 support and jqPlot will be dropped
#
class @JQPlotChartView extends BaseChartView
  create_legend: (opts) ->
    renderer: $.jqplot.EnhancedLegendRenderer
    show: true
    location: opts.location || 's'
    fontSize: @defaults.font_size
    placement: "outside" # This makes the legend overflow the plot container! Bad!
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

  pre_render: =>
    @clear_container()

  parsed_unit: ->
    unit = @model.get('unit')
    Metric.scale_unit(@max_value(), unit)

  # used when drawing the tick options on some chart types
  significant_digits: =>
    max = @max_value() / Math.pow(1000, @data_scale())
    return 0 if max >= 100
    return 1 if max >= 10
    return 2

  # returns the power of thousand of the largest value shown in the chart
  # this is used to scale the values around the chart
  data_scale: -> Metric.power_of_thousand @max_value()

