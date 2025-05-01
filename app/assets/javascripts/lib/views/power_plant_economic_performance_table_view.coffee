class @PowerPlantEconomicPerformance extends HtmlTableChartView
  after_render: =>
    @check_merit_enabled()
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
      capexEl = rowEl.find('td.capex')
      opexEl = rowEl.find('td.opex')
      revenueEl = rowEl.find('td.revenue')
      profitEl = rowEl.find('td.profit')

      if posEl.text() is '0'
        posEl.text('-').addClass('blank')
      else
        posEl.text(++position)

      if capexEl.text() is '0'
        capexEl.text('-').addClass('blank')

      if opexEl.text() is '0'
        opexEl.text('-').addClass('blank')

      if revenueEl.text() is '0'
        revenueEl.text('-').addClass('blank')

      if profitEl.text() is '0'
        profitEl.text('-').addClass('blank')

    @container_node().find("tbody").html(rows)

  # custom method to sort merit order table
  position: (item) ->
    klass = if App.settings.merit_order_enabled() then 'position' else 'profit'
    val = $(item).find("td.#{klass}").text()
    val = 0 if val == '-'
    +val
