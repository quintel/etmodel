@D3 = {}

class @D3YearlyChartView extends D3ChartView
  margins:
    top: 20
    bottom: 20
    left: 60
    right: 20

  drawChart: ->
    [@width, @height] = @available_size()

    @svg        = @create_svg_container @width, @height, @margins
    @chartData  = @dataForChart()

    @dateSelect = new D3ChartDateSelect(@container_selector(), @chartData[0].values.length)
    @dateSelect.draw(@updateData.bind(this))

    @xScale     = @drawXAxis()
    @yScale     = @drawYAxis()

    @drawData(@xScale, @yScale)


  drawLegend: (series, columns = 2) ->
    height = ((series.length + 1) / columns) * 15
    @draw_legend(
      svg:     @create_svg_container(@width, height, @margins),
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
      .attr("y", ((@margins.left / 2) * -1) - 30)
      .attr("x", ((@height / 2) * -1) + 30)
      .attr("dy", ".71em")
      .attr("font-weight", "bold")
      .style("text-anchor", "end")
      .text(@model.get('unit'))

    scale

  filterYValue: (value) ->
    value

  convertToDateRange: (serie) =>
    color:  serie.get('color'),
    label:  serie.get('label'),
    key:    serie.get('gquery').get('key'),
    values:  _.map(serie.future_value(), (value, hour) =>
                    x: new Date(hour * 3600000),
                    y: @filterYValue.call(serie, value))

  createLinearScale: ->
    d3.scale.linear().domain([0, @maxYvalue()]).range([@height, 0]).nice()

  createLinearAxis: (scale) ->
    d3.svg.axis().scale(scale).orient('left').ticks(7).tickSize(-@width, 0)

  createTimeScale: (domain) ->
    d3.time.scale.utc().range([0, @width]).domain(domain)

  createTimeAxis: (scale) ->
    formatting = (if @dateSelect.isWeekly() then "%b %d" else "%b")
    format = d3.time.format.utc(formatting)

    d3.svg.axis().scale(scale).orient('bottom').tickFormat(format).ticks(7)

  refresh: ->
    @chartData = @dataForChart()
    @updateData()
