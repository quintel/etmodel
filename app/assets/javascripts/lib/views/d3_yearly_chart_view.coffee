@D3 = {}

class @D3YearlyChartView extends D3ChartView
  margins:
    top: 20
    bottom: 20
    left: 65
    right: 2
    label_left: 30

  downsampleWith: 'mean'

  draw: ->
    [@width, @height] = @available_size()

    @svg          = @create_svg_container @width, @height, @margins
    @rawChartData = @dataForChart()

    @dateSelect = new D3ChartDateSelect(
      @container_selector(),
      @rawChartData[0].values.length,
      @downsampleWith
    )

    @dateSelect.draw(@refresh.bind(this))

    @xScale     = @drawXAxis()
    @yScale     = @drawYAxis()

  # Internal: Returns a function which will format values for the "main" axis
  # of the chart.
  main_formatter: (opts = {}) =>
    # Formatter allows values up to 100,000 before moving up to the next
    # magnitude.
    @create_scaler(@maxYvalue() / 100, @model.get('unit'), opts)

  dataForChart: ->
    @series = @model.non_target_series().concat(@model.target_series())
    @series.map(@getSerie)

  stackOffset: ->
    "zero"

  setStackedData: ->
    @chartData = @convertData()

    @stack = d3.layout.stack()
      .offset(@stackOffset())
      .values((d) -> d.values)

    stackedData = @getStackedData()

    @stackedData = stackedData.stacked
    @totalDemand = stackedData.total

  getStackedData: ->
    lastId = @chartData.length - 1

    stacked: @stack(@chartData[0...lastId]),
    total: [@chartData[lastId]]

  refresh: ->
    @rawChartData = @dataForChart()

    @svg.select('g.y_axis text.unit')
      .text(@main_formatter()(1).split(' ')[1])

  drawLegend: (series, columns = 2) ->
    height = ((series.length + 1) / columns) * 15

    $(@container_selector()).find("div.legend").remove()

    @draw_legend(
      series:  series,
      width:   @width,
      columns: columns
    )

  # Draws the X axis onto the charts, configuring the scaling and grey grid
  # lines.
  drawXAxis: ->
    scale = @createTimeScale([new Date(1970, 0, 0), new Date(1970, 11, 30)])
    axis  = @createTimeAxis(scale)

    @svg.append('g')
      .attr('class', 'x_axis inner_grid')
      .attr("transform", "translate(0,#{ @height })")
      .call(axis)

    scale

  # Draws the Y axis onto the charts, configuring the scaling and grey grid
  # lines.
  drawYAxis: ->
    scale = @createLinearScale()
    axis  = @createLinearAxis(scale)

    @svg.append('g')
      .attr('class', 'y_axis inner_grid')
      .call(axis)
      .append("text")
      .attr("transform", "rotate(-90)")
      .attr("class", "unit")
      .attr("y", ((@margins.left / 2) * -1) - @margins.label_left)
      .attr("x", ((@height / 2) * -1) + 12)
      .attr("dy", ".71em")
      .attr("font-weight", "bold")
      .style("text-anchor", "end")

    scale

  filterYValue: (value) ->
    value

  maxYvalue: ->
    targetKeys = @model.target_series().map((s) -> s.get('gquery_key'))
    grouped = _.groupBy(@visibleData(), (d) -> _.contains(targetKeys, d.key))

    targets = _.pluck(grouped[true], 'values')
    series = _.pluck(grouped[false], 'values')

    max = 0.0

    # Negatives, typically caused by storage charting, cause incorrect
    #calculation of the max value and result in incorrect vertical scaling.
    nonNegative = (val) ->
      if val < 0 then 0 else val

    for _load, index in series[0]
      aggregateLoad = d3.sum(series, (s) -> nonNegative(s[index]))
      targetLoad = d3.max(targets, (s) -> nonNegative(s[index]))

      if aggregateLoad > max then max = aggregateLoad
      if targetLoad > max then max = targetLoad

    max

  getSerie: (serie) =>
    # Creates a default array of values (8760 x 0.0) if the query does not have
    # a value. This may be the case if the user quickly loads one slide, then a
    # slide containing this chart: the chart will be rendered before the second
    # request containing data is received.
    color:     serie.get('color'),
    label:     serie.get('label'),
    key:       serie.get('gquery').get('key'),
    skip:      serie.get('skip'),
    is_target: serie.get('is_target_line')
    values:    serie.future_value() || Array.apply(null, Array(8760)).map(-> 0)

  createLinearScale: ->
    d3.scale.linear().domain([0, @maxYvalue()]).range([@height, 0]).nice()

  createLinearAxis: (scale) ->
    formatter = @main_formatter()

    d3.svg.axis().scale(scale)
      .orient('left')
      .ticks(7)
      .tickSize(-@width, 0)
      .tickFormat((v) => formatter(v).split(' ')[0])

  createTimeScale: (domain) ->
    d3.time.scale.utc().range([0, @width]).domain(domain)

  createTimeAxis: (scale) ->
    formatStr = if @dateSelect.isWeekly() then '%-d %b' else '%b'
    formatter = (val) -> I18n.strftime(val, formatStr)

    d3.svg.axis().scale(scale).orient('bottom')
      .tickValues(@dateSelect.tickValues()).tickFormat(formatter)

  visibleData: =>
    @rawChartData
      .filter (serie) ->
        serie.values.length
      .map (serie) =>
        $.extend({}, serie, values: MeritTransformator.transform(
          serie.values, this.dateSelect.val(), @downsampleWith
        ))

  convertData: =>
    @convertToXY(@visibleData())

  convertToXY: (data) =>
    dateVal = @dateSelect.val()
    seconds = if dateVal < 1 then 86400000 else 3600000
    offset  = if dateVal < 1 then 0 else 168 * (dateVal - 1)

    data.map((chart) =>
      chart.values = chart.values.map((value, hour) =>
        x: new Date((hour + offset) * seconds),
        y: @filterYValue.call(chart, value)
      )
      chart
    )
