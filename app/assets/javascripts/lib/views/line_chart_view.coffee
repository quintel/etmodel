class @LineChartView extends JQPlotChartView
  initialize: ->
    this.initialize_defaults()

  render: =>
    @pre_render()
    @render_line_chart()

  render_line_chart: =>
    $.jqplot @container_id(), @model.results(), @chart_opts()

  chart_opts: =>
    out =
      seriesColors: @model.colors()
      highlighter: @defaults.highlighter
      grid: @defaults.grid
      legend: @create_legend({num_columns: 2, offset: 20})
      seriesDefaults:
        lineWidth: 1.5
        showMarker: false
        yaxis:'y2axis'
        pointLabels:
          show: false
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
            formatString: "%.#{@significant_digits()}f&nbsp;#{@model.get('unit')}"
    out
