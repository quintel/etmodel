class @VariableEconomicPerformanceTableView extends HtmlTableChartView
  after_render: =>
    @check_merit_enabled()
    @sort_items()

  sort_items: =>
    rows = @container_node().find("tbody tr")

    # Keep only those with capacity > 0
    rows = _.select rows, (row) ->
      parseFloat($(row).find('td.capacity').text()) > 0

    # Sort by WTP (aka .position). zeros/NaN → -Infinity so they float to the top
    rows = _.sortBy rows, (row) ->
      val = parseFloat($(row).find('td.position').text())
      if isNaN(val) || val == 0 then -Infinity else -val

    @container_node().find("tbody").html(rows)
