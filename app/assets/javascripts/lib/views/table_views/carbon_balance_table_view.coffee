# Acts as a normal table, with the exception that the cell containing a query
# ending in "_used" will have its value compared with the cell ending in
# "_available". If used is higher than available, the cell will be highlighted
# with red text.
class @CarbonBalanceTableView extends @HtmlTableChartView
  after_render: =>
    for cell in @dynamic_cells()
      cellEl    = $(cell)
      gqueryKey = cellEl.data('gquery')

      continue unless gqueryKey && gqueryKey[-5..] == '_used'

      [selfVal, compVal] = @cell_balance_values(gqueryKey, cellEl.data('graph'))

      if selfVal && compVal && selfVal > compVal
        cellEl.addClass('warning')
      else
        cellEl.removeClass('warning')

  # Retrieves the value for a cell, and the value with which it should be
  # compared.
  cell_balance_values: (gqueryKey, period) =>
    series = [
      @model.series.with_gquery(gqueryKey),
      @model.series.with_gquery(gqueryKey.replace(/_used$/, '_available'))
    ]

    if period == 'present'
      _.map(series, (serie) => serie?.present_value())
    else
      _.map(series, (serie) => serie?.future_value())
