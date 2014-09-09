class @MeritOrderTableView extends HtmlTableChartView
  after_render: =>
    @sort_items()

  sort_items: =>
    # get rid of rows with -1 merit order position
    rows = @container_node().find("tbody tr")
    rows = _.reject rows, (item) => @position(item) == -1
    rows = _.select rows, (item) -> parseInt($(item).find('td.capacity').text(), 10)
    rows = _.sortBy rows, @position

    position = 0

    _.each rows, (row) ->
      rowEl  = $(row)
      posEl  = rowEl.find('td.position')
      costEl = rowEl.find('td.cost')

      if posEl.text() is '0'
        posEl.text('-').addClass('blank')
      else
        posEl.text(++position)

      if costEl.text() is '0'
        costEl.text('-').addClass('blank')

    @container_node().find("tbody").html(rows)

  # custom method to sort merit order table
  position: (item) ->
    klass = if App.settings.merit_order_enabled() then 'position' else 'cost'
    val = $(item).find("td.#{klass}").text()
    val = 0 if val == '-'
    +val
