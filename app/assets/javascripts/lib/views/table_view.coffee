class @TableView
  # Public: Creates a new TableView which will render data from a chart in a
  # table.
  constructor: (@chartView, options = {}) ->
    @model = @chartView.model
    @options = _.extend(@renderingOptions(), options)

  # Returns HTML containing the table, headers, and values.
  render: ->
    _.template($("#chart-table-template").html(), {
      data:        @seriesData(),
      totals:      @totalsData(),
      formatLabel: @options.labelFormatter(),
      formatValue: @options.valueFormatter(),
      formatTitle: @options.titleFormatter(),
      startYear:   App.settings.get('start_year'),
      endYear:     App.settings.get('end_year'),
    })

  # Creates an array of hashes, each one containing the ChartSerie, and the
  # present and future values.
  seriesData: ->
    _.map @options.sorter()(@getSeries()), (serie) ->
      serie:   serie
      present: serie.safe_present_value()
      future:  serie.safe_future_value()

  # Creates an array where the first element is the sum of the present values,
  # and the second is the sum of the future values.
  totalsData: ->
    if @options.showTotal()
      _.reduce(@model.results(true), (memo, row) ->
        memo[0] += row[0][1]
        memo[1] += row[1][1]
        memo
      , [0.0, 0.0])
    else
      []

  # Options which determine how to render each series in the table.
  renderingOptions: ->
    {
      labelFormatter: -> (serie) -> serie.get('label')
      showTotal:      => true
      valueFormatter: => @chartView.main_formatter(maxFrom: 'maxValue', maxPrecision: 5)
      titleFormatter: => @chartView.main_formatter(maxFrom: 'maxValue', maxPrecision: 10)
      sorter:         -> _.identity
    }

  # Returns all series, removing any duplicate target series.
  getSeries: ->
    _.union(@model.non_target_series(), _.uniq(
      @model.target_series(), false, (series) -> series.get('label')
    ))

# Renders each series with the name of the category to which it belongs. Retains
# the order of target series relative to the rest of the group, instead of
# showing them at the end of the list as in TableView.
class @CategoryTableView extends TableView
  # Include the group name with each series label.
  renderingOptions: ->
    opts = super()
    opts.labelFormatter = -> (serie) ->
      groupName = serie.get('group')
      translatedGroup = I18n.t("output_element_series.groups.#{groupName}")

      "#{translatedGroup}: #{serie.get('label')}"
    opts.showTotal = => @chartView.totals_for_table()

    opts

  getSeries: ->
    # Eliminate any series which have a dupliacte group and label (typically
    # taregt lines).
    _.uniq(@model.series.models, false, (serie) ->
      "#{serie.get('group')}.#{serie.get('label')}"
    )
