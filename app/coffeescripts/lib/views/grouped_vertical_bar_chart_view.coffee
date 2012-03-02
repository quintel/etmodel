class @GroupedVerticalBarChartView extends BaseChartView
  initialize : ->
    @initialize_defaults()

  render : =>
    @clear_container()
    InitializeGroupedVerticalBar(
      @model.get("container"),
      @result_serie(),
      @ticks(),
      @model.series.length,
      @parsed_unit(),
      @model.colors(),
      @model.labels())

  result_serie : ->
    _.flatten(@model.value_pairs())


  ticks: ->
    ticks = []
    @model.series.each (serie) ->
      ticks.push(serie.result()[0][0])
      ticks.push(serie.result()[1][0])
    ticks
