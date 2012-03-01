@VerticalStackedBarChartView = BaseChartView.extend
  initialize: -> 
    @initialize_defaults()

  render: -> 
    @clear_container()
    InitializeVerticalStackedBar(@model.get("container"), 
      @results(), 
      @ticks(),
      @filler(),
      @model.get('show_point_label'),
      @parsed_unit(),
      @model.colors(),
      @model.labels())

  results : () ->
    results = @results_without_targets()
    scale = @data_scale()

    if !@model.get('percentage')
      results = _.map results, (x) ->
        return _.map x, (value) ->
          return Metric.scale_value(value, scale)

    for serie in @model.target_series()
      result = serie.result()[0][1]; # target_series has only present or future value
      result = Metric.scale_value(result, scale)
      x = parseFloat(serie.get('target_line_position'))
      results.push([[x - 0.4, result], [x + 0.4, result]])
    return results

  results_without_targets: ->
    return _.map @model.non_target_series(), (serie) -> 
      return serie.result_pairs()

  filler: ->
    return _.map @model.non_target_series(), (serie) ->
      return {}

  ticks: ->
    return [App.settings.get("start_year"), App.settings.get("end_year")]
