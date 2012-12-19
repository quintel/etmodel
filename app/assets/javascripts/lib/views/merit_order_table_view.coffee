class @MeritOrderTableView extends HtmlTableChartView
  after_render: =>
    @sort_items()

  sort_items: =>
    # get rid of rows with -1 merit order position
    rows = @container_node().find("tbody tr")
    rows = _.reject rows, (item) => @position(item) == -1
    unless App.settings.merit_order_enabled()
      # hide items with 0 capacity
      rows = _.reject rows, (item) -> +$(item).find('td.capacity').text() == 0
    rows = _.sortBy rows, @position
    @container_node().find("tbody").html(rows)

  # custom method to sort merit order table
  position: (item) ->
    klass = if App.settings.merit_order_enabled() then 'position' else 'cost'
    val = $(item).find("td.#{klass}").text()
    val = 0 if val == '-'
    +val
