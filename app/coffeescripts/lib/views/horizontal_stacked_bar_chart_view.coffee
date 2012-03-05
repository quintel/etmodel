class @HorizontalStackedBarChartView extends BaseChartView
  cached_results : null

  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_results_cache()
    @clear_container()
    @render_chart()

  # the horizontal stacked graph expects data in this format:
  # [[value1, 1], [value1, 2]],[[value2, 1], [value2, 2]] ...
  results: ->
    series = {}
    # parse all the results into a hash by group and add the serie number to it
    @model.series.each (serie) ->
      group = serie.get('group')
      if (group)
        series[group] = [] unless series[group]
        series[group].push([serie.result_pairs()[0],(series[group].length + 1)])
    #jqplot needs and array so we create this by mapping the hash
    _.map series, (values, group) -> values

  clear_results_cache: ->
    @cached_results = null

  axis_scale: ->
    min = @model.get('min_axis_value')
    max = @model.get('max_axis_value')
    [min, max]

  ticks: ->
    groups = @model.series.map (serie) -> serie.get('group_translated')
    _.uniq(groups)

  colors: ->
    _.uniq(@model.colors())

  labels: ->
    _.uniq(@model.labels())

  render_chart: =>
    $.jqplot @container_id(), @results(), @chart_opts()

  chart_opts: =>
    out =
      stackSeries: true
      seriesColors: @colors()
      grid: default_grid
      legend: create_legend(6,'s',@ticks())
      seriesDefaults:
        renderer: $.jqplot.BarRenderer
        pointLabels:
          show: @model.get('show_point_label')
        rendererOptions:
          barDirection: 'horizontal'
          varyBarColor: true
          barPadding: 8
          barMargin: 30
          shadow: shadow
      axes:
        yaxis:
          renderer: $.jqplot.CategoryAxisRenderer
          ticks: @labels()
        xaxis:
          min: @axis_scale()[0] # axis values are still used in this chart type because of the ability to set them in the database.
          max: @axis_scale()[1]
          numberTicks: 5,
          tickOptions:
            formatString: "%.2f#{@model.get('unit')}"
            fontSize: '10px'
    out
