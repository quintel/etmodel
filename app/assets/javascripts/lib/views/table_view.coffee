class @TableView
  # Public: Creates a new TableView which will render data from a chart in a
  # table.
  constructor: (@chartView, options = {}) ->
    @model = @chartView.model

    @options = _.extend({
      labelFormatter: -> (serie) -> serie.get('label')
      valueFormatter: => @chartView.main_formatter(precision: 4)
      sorter:         -> _.identity
    }, options)

  # Returns HTML containing the table, headers, and values.
  render: ->
    _.template($("#chart-table-template").html(), {
      data:        @seriesData(),
      totals:      @totalsData(),
      formatLabel: @options.labelFormatter(),
      formatValue: @options.valueFormatter(),
      startYear:   App.settings.get('start_year'),
      endYear:     App.settings.get('end_year')
    })

  # Creates an array of hashes, each one containing the ChartSerie, and the
  # present and future values.
  seriesData: ->
    series = _.union(@model.non_target_series(), _.uniq(
      # Target series, with duplicates removed.
      @model.target_series(), false, (series) -> series.get('label')
    ))

    _.map @options.sorter()(series), (serie) ->
      serie:   serie
      present: serie.safe_present_value()
      future:  serie.safe_future_value()

  # Creates an array where the first element is the sum of the present values,
  # and the second is the sum of the future values.
  totalsData: ->
    _.reduce(@model.results(true), (memo, row) ->
      memo[0] += row[0][1]
      memo[1] += row[1][1]
      memo
    , [0.0, 0.0])
