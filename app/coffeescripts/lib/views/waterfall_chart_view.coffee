class @WaterfallChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()
    @HEIGHT = '460px'

  render: =>
    @clear_container()
    InitializeWaterfall(@model.get("container"),
      @results(),
      @model.get('unit'),
      @colors(),
      @labels())

  colors: ->
    colors = @model.colors()
    colors.push(colors[0]); # add the color of the first serie again to set a color for the completing serie
    colors

  labels: ->
    labels = @model.labels()
    # RD: USING ID's IS A MASSIVE FAIL!!
    label = if @model.get('id') == 51 then App.settings.get("end_year") else 'Total'
    labels.push label
    labels

  results: ->
    series = @model.series.map (serie) ->
      present = serie.result_pairs()[0]
      future = serie.result_pairs()[1]
      if serie.get('group') == 'value'
        return present # Take only the present value, as group == value queries only future/present
      else
        return future - present
    # TODO: Add scaling!
    series
