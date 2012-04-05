class @HorizontalBarChartView extends BaseChartView
  cached_results: null

  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_results_cache()
    @clear_container()
    @render_chart()

  # the horizontal graph expects data in this format:
  # [value, 1], [value, 2], ...
  # TODO: refactoring - PZ Tue 3 May 2011 17:44:14 CEST
  results: ->
    return @cached_results if @cached_results
    model_results = @model.results()
    scale = @data_scale()
    out = []
    for i in [0...model_results.length]
      value = model_results[i][0][1]
      scaled = Metric.scale_value(value, scale)
      out.push([scaled, parseInt(i)+1])
    @cached_results = out
    [out]

  clear_results_cache: -> @cached_results = null

  render_chart: =>
    $.jqplot @container_id(), @results(), @chart_opts()

  chart_opts: =>
    out =
      seriesColors: @model.colors()
      highlighter: @defaults.highlighter
      grid: @defaults.grid
      seriesDefaults:
        renderer: $.jqplot.BarRenderer
        pointLabels:
          show: true
        rendererOptions:
          barDirection: 'horizontal'
          varyBarColor: true
          barPadding: 6
          barMargin: 100
          shadow: @defaults.shadow
      axes:
        yaxis:
          renderer: $.jqplot.CategoryAxisRenderer
          ticks: @model.labels()
        xaxis:
          rendererOptions:
            forceTickAt0: true # we always want a tick a 0
          numberTicks: 6
          tickOptions:
            formatString: "%.1f#{@parsed_unit()}"
    out

