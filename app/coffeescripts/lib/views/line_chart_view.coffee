class @LineChartView extends BaseChartView
  initialize: ->
    this.initialize_defaults()

  render: =>
    @clear_container()
    @render_line_chart()

  render_line_chart: =>
    $.jqplot @container_id(), @model.results(), @chart_opts()

  chart_opts: =>
    out =
      seriesColors: @model.colors()
      grid: @defaults.grid
      legend: create_legend(2,'s', @model.labels(), 20)
      seriesDefaults:
        lineWidth: 1.5
        showMarker: false
        yaxis:'y2axis'
      axes:
        xaxis:
          numberTicks:2
          tickOptions:
            fontSize: @defaults.font_size
            showGridline: false
        y2axis:
          rendererOptions:
            forceTickAt0: true # we always want a tick at 0
          tickOptions:
            formatString: "%.0f&nbsp;#{@model.get('unit')}"
    out
