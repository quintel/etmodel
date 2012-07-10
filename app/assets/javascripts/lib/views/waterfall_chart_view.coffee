class @WaterfallChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_container()
    @render_waterfall()

  colors: ->
    colors = @model.colors()
    colors.push(colors[0]); # add the color of the first serie again to set a color for the completing serie
    colors

  labels: ->
    labels = @model.labels()
    # RD: USING ID's IS A MASSIVE FAIL!!
    label = if @model.get('id') == 51 then App.settings.get("end_year") else 'Total'
    labels.push label
    labels

  results: ->
    scale = @data_scale()
    series = @model.series.map (serie) ->
      present = serie.present_value()
      future = serie.future_value()
      if serie.get('group') == 'value'
        # Take only the present value, as group == value queries only future/present
        # ?! - PZ
        return present # Metric.scale_value present, scale
      else
        return future # Metric.scale_value future, scale
    [series]

  render_waterfall: =>
    $.jqplot @model.get("container"), @results(), @chart_opts()

  chart_opts: =>
    out =
      seriesColors: @colors()
      highlighter: @defaults.highlighter
      grid: @defaults.grid
      seriesDefaults:
        shadow: @defaults.shadow
        renderer: $.jqplot.BarRenderer
        rendererOptions:
          waterfall: true
          varyBarColor: true
          useNegativeColors: false
          barWidth: 25
        pointLabels:
          ypadding: -5
          formatString: '%.0f'
        yaxis:'y2axis'
      axes:
        xaxis:
          renderer: $.jqplot.CategoryAxisRenderer
          ticks: @labels()
          tickRenderer: $.jqplot.CanvasAxisTickRenderer
          tickOptions:
            angle: -90
            showGridline: false
            fontSize: '10px'
        y2axis:
          rendererOptions:
            forceTickAt0: true # we always want a tick a 0
          tickOptions:
            formatString: "%.#{@significant_digits()}f&nbsp;#{@model.get('unit')}"
