class @GroupedVerticalBarChartView extends JQPlotChartView
  initialize : ->
    @initialize_defaults()

  render : =>
    @pre_render()
    @render_chart()

  result_serie : -> _.flatten(@model.value_pairs())

  ticks: ->
    ticks = []
    @model.series.each (serie) ->
      ticks.push(serie.result()[0][0])
      ticks.push(serie.result()[1][0])
    ticks

  results: -> [@result_serie()]

  render_chart: =>
    @.jqplot @container_id(), @results(), @chart_opts()

  chart_opts: =>
    out =
      grid: @defaults.grid
      highlighter: @defaults.highlighter
      stackSeries: true
      seriesColors: @model.colors()
      seriesDefaults:
        renderer: $.jqplot.BarRenderer
        rendererOptions:
          groups: @model.series.length
          barWidth: 20
        pointLabels:
          show: false
        yaxis:'y2axis'
        shadow: @defaults.shadow
      axesDefaults:
        tickOptions:
          fontSize: @defaults.font_size
      axes:
        xaxis:
          ticks: @ticks()
           rendererOptions:
             groupLabels: @model.labels()
          renderer: $.jqplot.CategoryAxisRenderer
          tickOptions:
            showGridline: false
            markSize: 0
            pad: 1.00
        y2axis:
          tickOptions:
            formatString: "%d&nbsp;#{@parsed_unit()}"

    out
