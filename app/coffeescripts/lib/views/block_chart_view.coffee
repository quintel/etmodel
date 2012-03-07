class @BlockChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    $("a.select_chart").hide()
    $("a.toggle_chart_format").hide()
    update_block_charts(@model.series.map (serie) -> serie.result())

  can_be_shown_as_table: -> false
