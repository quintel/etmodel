class @LineChartView extends BaseChartView
  initialize: ->
    this.initialize_defaults()

  render: =>
    @clear_container()
    InitializeLine(@model.get("container"),
      @model.results(),
      @model.get('unit'),
      @model.colors(),
      @model.labels())
