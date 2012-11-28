class @MekkoChartView extends JQPlotChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @pre_render()
    @render_mekko()

  results: ->
    series = {}
    @model.series.each (serie) ->
      group = serie.get('group')
      if group
        if (!series[group]) then series[group] = []
        series[group].push(serie.future_value())
    results = _.map series, (sector_values, sector) ->
      return _.map sector_values, (value) ->
        return value
    results

  colors: ->
    _.uniq(@model.colors())

  labels: ->
    # TODO: the old model also has percentage per group. was ommited to simplify things.
    return _.uniq(@model.labels())

  group_labels:->
    group_labels = @model.series.map (serie) -> serie.get('group_translated')
    return _.uniq(group_labels)

  render_mekko: =>
    $.jqplot @model.get("container"), @results(), @chart_opts()
    $(".jqplot-xaxis").css({"margin-left": -10,"margin-top":0})
    $(".jqplot-table-legend").css({"top": 320})
    # this hides the labels appearing in the middle of the charts. Looks like a jqplot bug
    # See https://github.com/dennisschoenmakers/etmodel/issues/639
    $(".jqplot-point-label").html(null)
    # prevent the legend from overlapping the secondary chart

  chart_opts: =>
    out =
      grid: @defaults.grid
      legend: @create_legend({num_columns: 3, labels: @labels(), offset: 155})
      seriesDefaults:
        renderer: $.jqplot.MekkoRenderer
        rendererOptions:
          borderColor: "#999999"
      seriesColors: @colors()
      axesDefaults:
        renderer:$.jqplot.MekkoAxisRenderer
        tickOptions:
          fontSize: @defaults.font_size
          markSize: 0
      axes:
        xaxis:
          barLabels: @group_labels()
          rendererOptions:
            barLabelOptions:
              fontSize: @defaults.font_size
              angle: -45
            barLabelRenderer: $.jqplot.CanvasAxisLabelRenderer
          tickOptions:
            formatString:'&nbsp;' # hide the ticks on this axis by formatting the value as a space
        x2axis:
          show: true
          tickMode: 'bar'
          tickOptions:
            formatString: '%d&nbsp;' + @model.get('unit')
          rendererOptions:
            barLabelOptions:
              angle: 90
    out
