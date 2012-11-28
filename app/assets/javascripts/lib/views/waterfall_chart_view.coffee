class @WaterfallChartView extends JQPlotChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @pre_render()
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
    series = @model.series.map (serie) =>
      present = serie.present_value()
      future = serie.future_value()
      # There is a conflict between code and documentation. If the serie's
      # group is set to 'value' then we're interested in the present value, if
      # 'future' we want the future value, otherwise in the difference
      # future-present. If I got it right.
      #
      g = serie.get('group')
      val = if g == 'future'
        future
      else if g == 'value' # ?! TODO: rename!
        present
      else
        future - present
      if @scale_units() then Metric.scale_value(val, scale) else val
    [series]

  scale_units: => @model.get('unit') != 'PJ'

  tick_unit: => if @scale_units() then @parsed_unit() else @model.get('unit')

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
          padMax: 1.1
          rendererOptions:
            forceTickAt0: true # we always want a tick a 0
          tickOptions:
            formatString: "%.#{@significant_digits()}f&nbsp;#{@tick_unit()}"
