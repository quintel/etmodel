# ATTENTION: This chart type is only used in the co2 dashbord and therefore quite custom
# It contains some custom additions to the series showing a historic value
class @VerticalBarChartView extends VerticalStackedBarChartView
  render: =>
    @clear_container()
    @render_chart()

  results: ->
    results = @results_with_1990()
    target_serie = @model.target_series()[0]
    result = target_serie.safe_future_value()

    x = parseFloat(target_serie.get('target_line_position'))
    results.push([[x - 0.4, result], [x + 0.4, result]])
    results

  # custom function for showing 1990
  results_with_1990: ->
    result = @model.results()
    [[result[0][1][1],result[1][0][1],result[1][1][1]]]

  ticks: ->
    # added 1990 in the code here, this is the only charts that uses @
    [1990, App.settings.get("start_year"), App.settings.get("end_year")]

  filler: ->
    # add this filler to create a dummy value. This is needed because the target
    # line must be added to the end of the serie
    [{}]

  parsed_unit: -> 'MT'

  can_be_shown_as_table: -> false
