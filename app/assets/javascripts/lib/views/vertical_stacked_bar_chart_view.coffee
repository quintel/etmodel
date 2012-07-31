class @VerticalStackedBarChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_container()
    @render_chart()

  results: ->
    results = @results_without_targets()
    scale = @data_scale()

    if !@model.get('percentage')
      results = _.map results, (x) ->
        return _.map x, (value) ->
          return Metric.scale_value(value, scale)

    for serie in @model.target_series()
      result = serie.result()[0][1]; # target_series has only present or future value
      result = Metric.scale_value(result, scale)
      x = parseFloat(serie.get('target_line_position'))
      results.push([[x - 0.4, result], [x + 0.4, result]])
    return results

  results_without_targets: ->
    _.map @model.non_target_series(), (s) ->
      [s.safe_present_value(), s.safe_future_value()]

  filler: ->
    return _.map @model.non_target_series(), (serie) ->
      return {}

  ticks: ->
    return [App.settings.get("start_year"), App.settings.get("end_year")]

  render_chart: =>
    $.jqplot @container_id(), @results(), @chart_opts()

  chart_opts: =>
    grid: @defaults.grid
    highlighter: @defaults.highlighter
    legend: @create_legend({num_columns: 3})
    stackSeries: true,
    seriesColors: @model.colors()
    seriesDefaults:
      shadow: @defaults.shadow
      renderer: $.jqplot.BarRenderer
      rendererOptions:
        barPadding: 0
        barMargin: 110
        barWidth: 80
      pointLabels: # a pointlabel is a value shown besides the serie inside the grid.
        show: @model.get('show_point_label') # want to show point labels?
        stackedValue: true # sum the values of all the series in one point label
        formatString: '%.1f'
        edgeTolerance: -50
        ypadding: 0
      yaxis:'y2axis' # use the right side of the chart for the y-axis
    series: @apply_target_line_serie_settings(@filler())
    axes:
      xaxis:
        renderer: $.jqplot.CategoryAxisRenderer
        ticks: @ticks()
        tickOptions:
          showMark: false # no marks on the x axis
          showGridline: false # no vertical gridlines
      y2axis:
        borderColor:'#cccccc', # color for the marks #cccccc is the same as the grid lines
        rendererOptions:
          forceTickAt0: true
        tickOptions:
          formatString: "%.#{@significant_digits()}f&nbsp;#{@parsed_unit()}"

  apply_target_line_serie_settings: (serie_settings_filler) ->
    # add the target line settings to the series.
    # when the target line is the 5th serie in the charts, the serie_settings_filler
    # will look like this: [{},{},{},{}]
    # this means that the settings of the first 4 series wont be changed.
    # ?! - PZ
    if serie_settings_filler.length > 0
      target_serie_settings = [
        {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:true},
        {renderer:$.jqplot.LineRenderer, disableStack:true, lineWidth: 1.5, shadow:true, showMarker:false, showLabel:false}
      ]
      return serie_settings_filler.concat(target_serie_settings);
    else
      return []
