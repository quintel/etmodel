class @HtmlTableChartView extends BaseChartView
  initialize : ->
    @initialize_defaults()

  render : =>
    @clear_container()
    @container_node().html(window.table_content)
    @fill_cells()
    # sort rows on merit order chart
    @merit_order_sort() if @model.get("id") == 116

  fill_cells : ->
    @dynamic_cells().each ->
      gqid = $(this).data('gquery')
      gquery = window.gqueries.with_key(gqid)
      return unless gquery
      raw_value = gquery.future_value()
      value = Metric.round_number(raw_value, 1)
      $(this).html(value)

  # returns a jQuery collection of cells to be dynamically filled
  dynamic_cells : ->
    @container_node().find("td[data-gquery]")

  can_be_shown_as_table: -> false

  merit_order_sort: =>
    rows = _.sortBy $("##{@container_id()} tbody tr"), @merit_order_position
    # get rid of rows with merit order of 1000. See ETE#193.
    # Ugly solution until we use better gqueries
    rows = _.reject rows, (item) => @merit_order_position(item) == 1000
    @container_node().find("tbody").html(rows)

  # custom method to sort merit order table
  # DEBT: this should be resolved at gquery level
  merit_order_position: (item) ->
    parseInt($(item).find("td:first").text())
