class @HtmlTableChartView extends BaseChartView
  initialize : ->
    @initialize_defaults()

  render : =>
    @clear_container()
    @container_node().html(window.table_content)
    @fill_cells()
    # sort rows on merit order chart
    @sort() if @model.get("id") == 116

  fill_cells : ->
    @dynamic_cells().each ->
      gqid = $(this).data('gquery_id')
      gquery = window.gqueries.with_key(gqid)[0]
      return unless gquery
      raw_value = gquery.result()[1][1]
      value = Metric.round_number(raw_value, 1)
      $(this).html(value)

  # returns a jQuery collection of cells to be dynamically filled
  dynamic_cells : ->
    @container_node().find("td")

  can_be_shown_as_table: -> false

  sort: =>
    rows = _.sortBy $("##{@container_id()} tbody tr"), @sortMethod
    @container_node().find("tbody").html(rows)

  sortMethod: (item) ->
    parseInt($(item).find("td:first").text())
