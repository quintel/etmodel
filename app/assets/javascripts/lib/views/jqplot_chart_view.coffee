class @JQPlotChartView extends BaseChartView
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

  pre_render: =>
    @clear_container()
    @resize_container()
