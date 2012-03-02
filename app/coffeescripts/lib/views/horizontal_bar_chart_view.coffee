class @HorizontalBarChartView extends BaseChartView
  cached_results: null

  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_results_cache()
    @clear_container()
    InitializeHorizontalBar(
      @model.get("container"),
      @results(),
      true,
      @parsed_unit(),
      @model.colors(),
      @model.labels()
    )

  # the horizontal graph expects data in this format:
  # [value, 1], [value, 2], ...
  # TODO: refactoring - PZ Tue 3 May 2011 17:44:14 CEST
  results: ->
    return @cached_results if @cached_results
    model_results = @model.results()
    scale = @data_scale()
    out = []
    for i in [0..model_results.length-1]
      value = model_results[i][0][1]
      scaled = Metric.scale_value(value, scale)
      out.push([scaled, parseInt(i)+1])
    @cached_results = out
    out

  clear_results_cache: ->
    @cached_results = null

