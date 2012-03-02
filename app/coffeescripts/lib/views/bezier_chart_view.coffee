class @BezierChartView extends BaseChartView
  initialize : ->
    @initialize_defaults()

  render: =>
    @clear_container()
    InitializeBezier(@model.get("container"),
      @scaled_results(),
      @model.get("growth_chart"),
      @parsed_unit(),
      @model.colors(),
      @model.labels())

  # if we scale the label we've got to scale the values, too
  scaled_results: ->
    scale = @data_scale()
    _.map @model.results(), (gquery) ->
      _.map gquery, (pair) ->
        [pair[0], Metric.scale_value(pair[1], scale)]
