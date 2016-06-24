class @MeritOrderExcessTableView extends TableView
  # Returns HTML containing the table, headers, and values.
  render: ->
    _.template($("#merit-order-excess-chart-table-template").html(), {
      data: @seriesData()
    })

  seriesData: ->
    @model.non_target_series()[0].safe_future_value()
