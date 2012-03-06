class @ScatterChartView extends BaseChartView
  initialize: ->
    this.initialize_defaults()

  render: =>
    @clear_container()
    @render_chart()

  results: =>
    [
      [[3,4]],
      [[7,9]],
      [[2,6]]
    ]

  render_chart: =>
    $.jqplot @container_id(), @results(), @chart_opts()

  x_axis_unit: =>
    @model.get('unit').split(';')[0]

  y_axis_unit: =>
    @model.get('unit').split(';')[1]

  chart_opts: =>

    out =
      seriesColors: @model.colors()
      grid: @defaults.grid
      seriesDefaults:
        lineWidth: 1.5
        showMarker: true
        yaxis:'yaxis'
      axes:
        xaxis:
          rendererOptions:
            forceTickAt0: true # we always want a tick at 0
          numberTicks: 5
          tickOptions:
            fontSize: @defaults.font_size
            showGridline: true
            formatString: "%.1f&nbsp;#{@x_axis_unit()}"
        yaxis:
          rendererOptions:
            forceTickAt0: true # we always want a tick at 0
          tickOptions:
            formatString: "%.1f&nbsp;#{@y_axis_unit()}"
    out
