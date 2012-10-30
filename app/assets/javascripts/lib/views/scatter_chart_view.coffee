class @ScatterChartView extends BaseChartView
  initialize: ->
    this.initialize_defaults()

  render: =>
    @clear_container()
    @$el.css('height', 470)
    @render_chart()

  results: =>
    @model.series.map (serie) ->
      pres = serie.result()[0]
      future = serie.result()[1]
      label = serie.get('label')
      [[pres, future, label]] #[serie.result()]

  render_chart: =>
    $.jqplot @container_id(), @results(), @chart_opts()

  # This chart isn't actually scaling the values, so
  # we're packing the labels in the unit column
  x_axis_unit: => @model.get('unit').split(';')[0]

  y_axis_unit: => @model.get('unit').split(';')[1]

  can_be_shown_as_table: -> false

  chart_opts: =>
    out =
      seriesColors: @model.colors()
      grid: @defaults.grid
      legend: @create_legend({num_columns: 4, offset: 60})
      seriesDefaults:
        lineWidth: 1.5
        showMarker: true
        markerOptions:
          size: 12.0
          style: 'filledCircle'
        yaxis:'yaxis'
        pointLabels:
          show: false
      axesDefaults:
        labelRenderer: $.jqplot.CanvasAxisLabelRenderer
        labelOptions:
          fontSize: '13px'
          textColor: "#000000"
        rendererOptions:
          forceTickAt0: true # we always want a tick at 0
        numberTicks: 5
        tickOptions:
          fontSize: @defaults.font_size
          showGridline: true
          formatString: "%.1f"
      axes:
        xaxis:
          label: @x_axis_unit()
        yaxis:
          label: @y_axis_unit()
      highlighter:
        show: true
        sizeAdjust: 7.5
        yvalues: 3
        formatString: '(%s, %s) %s'
        tooltipLocation: 'ne'
    out
