class @PolicyBarChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_container()
    InitializePolicyBar(@model.get("container"),
      @result_serie1(),
      @result_serie2(),
      @ticks(),
      @model.series.length,
      @parsed_unit(),
      @model.colors(),
      @model.labels())

  result_serie1: ->
    out = _.flatten(this.model.value_pairs())
    if (this.model.get("percentage"))
      out = _(out).map (x) -> x * 100
    out

  result_serie2: ->
    _.map @result_serie1(), (r) -> 100 - r

  ticks: ->
    ticks = []
    @model.series.each (serie) ->
      ticks.push(serie.result()[0][0])
      ticks.push(serie.result()[1][0])
    ticks
