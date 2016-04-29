D3.merit_order_price_curve =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    draw: ->
      @drawChart()
      @dateSelect.setVal(1)

    dataForChart: ->
      @model.non_target_series().map(@convertToDateRange)

    drawData: (xScale, yScale) ->
      line = @line(xScale, yScale)

      @svg.selectAll('path.serie')
        .data(@chartData)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr('class', 'serie')
        .append('path')
        .attr('class', 'line')
        .attr('d', (data) -> line(data.values) )
        .attr('stroke', (data) -> data.color )
        .attr('stroke-width', 2)
        .attr("style", "shape-rendering: crispEdges;")
        .attr('fill', 'none')

    line: (xScale, yScale) ->
      d3.svg.line()
        .x((data) -> xScale(data.x))
        .y((data) -> yScale(data.y))
        .interpolate('step-after')

    updateData: ->
      @chartData = new MeritTransformator(this, @chartData).transform()

      xScale = @createTimeScale(@dateSelect.getCurrentRange())
      yScale = @createLinearScale()
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      @svg.selectAll('g.serie')
        .data(@chartData)
        .select('path.line')
        .attr('d', (data) -> line(data.values) )

    maxYvalue: ->
      d3.max(@chartData[0].values.map((point) -> point.y))

