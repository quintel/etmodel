class @HtmlTableChartView extends BaseChartView
  initialize : ->
    @initialize_defaults()

  render : =>
    @clear_container()
    @model.container_node().html(window.table_content)
    @fill_cells()

  fill_cells : ->
    console.log("Filling cells")
    @dynamic_cells().each ->
      gqid = $(this).data('gquery_id')
      gquery = window.gqueries.with_key(gqid)[0]
      return unless gquery
      raw_value = gquery.result()[1][1]
      value = Metric.round_number(raw_value, 1)
      $(this).html(value)

  # returns a jQuery collection of cells to be dynamically filled
  dynamic_cells : ->
    @model.container_node().find("td")
