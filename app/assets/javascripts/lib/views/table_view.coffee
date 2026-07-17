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
      total1990:   @total1990Data(),
      has1990:     @has1990(),
      formatLabel: @options.labelFormatter(),
      formatValue: @options.valueFormatter(),
      formatTitle: @options.titleFormatter(),
      startYear:   App.settings.get('start_year'),
      endYear:     App.settings.get('end_year'),
    })

  # True when the chart has 1990 series; the table then gains a 1990 column.
  has1990: -> @model.year_1990_series().length > 0

  # Creates an array of hashes, each one containing the ChartSerie, and the
  # 1990 (when the chart has 1990 series), present, and future values.
  seriesData: ->
    rows = _.map @options.sorter()(@getSeries()), (serie) =>
      serie:     serie
      year_1990: @year1990Value(serie)
      present:   serie.safe_present_value()
      future:    serie.safe_future_value()

    extraRows = @unmatched1990Rows(rows)
    return rows unless extraRows.length

    # Insert the extra 1990 rows above the target lines.
    targetRows = _.filter(rows, (row) -> row.serie.get('is_target_line'))
    normalRows = _.reject(rows, (row) -> row.serie.get('is_target_line'))

    normalRows.concat(extraRows, targetRows)

  # The 1990 value for a serie: target lines take the value of the target line
  # at position 1990 with the same label, other series that of the 1990 serie
  # with the same label. Null when the chart has neither.
  year1990Value: (serie) ->
    label = serie.get('label_key')

    match = if serie.get('is_target_line')
      _.find @model.target_series(), (s) ->
        s.get('label_key') == label && s.get('target_line_position') == '0'
    else
      _.find @model.year_1990_series(), (s) ->
        s.get('label_key') == label

    if match then match.safe_present_value() else null

  # Rows for 1990 series which don't share a label with any other row, such as
  # the consolidated 1990 series in the CO2 emissions chart. These only have a
  # 1990 value.
  unmatched1990Rows: (rows) ->
    labels = _.map rows, (row) -> row.serie.get('label_key')

    unmatched = _.reject @model.year_1990_series(), (serie) ->
      _.contains(labels, serie.get('label_key'))

    _.map unmatched, (serie) ->
      serie:     serie
      year_1990: serie.safe_present_value()
      present:   null
      future:    null

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

  # The sum of the 1990 values, or null when the chart has no 1990 series or
  # shows no totals.
  total1990Data: ->
    if @options.showTotal() && @has1990()
      _.sum(@model.values_1990())
    else
      null

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
