class @HorizontalStackedBarChartView extends BaseChartView
  cached_results : null

  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_results_cache()
    @clear_container()
    InitializeHorizontalStackedBar(
      @model.get("container"),
      @results(),
      @ticks(),
      @model.get('show_point_label'),
      @model.get('unit'),
      @axis_scale(),
      @colors(),
      @labels())

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

