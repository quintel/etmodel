class @PolicyBarChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_container()
    @render_chart()

  result_serie1: ->
    out = _.flatten(@model.value_pairs())
    if @model.get("percentage")
      out = _(out).map (x) -> x * 100
    out

  result_serie2: ->
    _.map @result_serie1(), (r) -> (100 - r)

  results: => [@result_serie1(), @result_serie2()]

  ticks: ->
    ticks = []
    @model.series.each (s) ->
      ticks.push App.settings.get('start_year')
      ticks.push App.settings.get('end_year')
    ticks

  render_chart: =>
    $.jqplot @container_id(), @results(), @chart_opts()

  chart_opts: =>
    out =
      grid: @defaults.grid
      highlighter: @defaults.highlighter
      stackSeries: true
      seriesColors: [@model.colors()[0], "#CCCCCC"]
      seriesDefaults:
        renderer: $.jqplot.BarRenderer
        rendererOptions:
          groups: @model.series.length
          barWidth: 35
        pointLabels:
          stackedValue: true
        yaxis:'y2axis',
        shadow: @defaults.shadow
      series:
        [{pointLabels: {ypadding: -18}}, {pointLabels: {ypadding: 9000}}] # this hack will push the labels for the top series off of the page so they don't appear
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
            pad: 3.00
        y2axis:
          ticks: [0,100] # this charts is alway a percentage
          tickOptions:
            formatString: '%d\%'
    out
