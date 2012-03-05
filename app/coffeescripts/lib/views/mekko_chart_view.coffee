class @MekkoChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_container()
    @render_mekko()

  results: ->
    scale = @data_scale()
    series = {}
    values = []
    @model.series.each (serie) ->
      group = serie.get('group')
      if group
        if (!series[group]) then series[group] = []
        series[group].push(serie.result_pairs()[0])
        values.push(serie.result_pairs()[0])
    results = _.map series, (sector_values, sector) ->
      return _.map sector_values, (value) ->
        return Metric.scale_value(value, scale)
    results

  colors: ->
    _.uniq(@model.colors())

  labels: ->
    labels = @model.labels()
    # TODO: the old model also has percentage per group. was ommited to simplify things.
    return _.uniq(labels)

  group_labels:->
    group_labels = @model.series.map (serie) -> serie.get('group_translated')
    return _.uniq(group_labels)

  render_mekko: =>
    $.jqplot @model.get("container"), @results(), @chart_opts()
    $(".jqplot-xaxis").css({"margin-left": -10,"margin-top":0})
    $(".jqplot-table-legend").css({"top": 340})

  chart_opts: =>
    out =
      grid: default_grid
      legend: create_legend(3,'s', @labels(), 155)
      seriesDefaults:
        renderer: $.jqplot.MekkoRenderer
        rendererOptions:
          borderColor: "#999999"
      seriesColors: @colors()
      axesDefaults:
        renderer:$.jqplot.MekkoAxisRenderer
        tickOptions:
          fontSize: font_size
          markSize: 0
      axes:
        xaxis:
          barLabels: @group_labels()
          rendererOptions:
            barLabelOptions:
              fontSize: font_size
              angle: -45
            barLabelRenderer: $.jqplot.CanvasAxisLabelRenderer
          tickOptions:
            formatString:'&nbsp;' # hide the ticks on this axis by formatting the value as a space
        x2axis:
          show: true
          tickMode: 'bar'
          tickOptions:
            formatString: '%d&nbsp;' + @parsed_unit()
    out
