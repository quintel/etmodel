class @BlockChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    $("a.select_chart").hide()
    update_block_charts(@model.series.map (serie) -> serie.result())
