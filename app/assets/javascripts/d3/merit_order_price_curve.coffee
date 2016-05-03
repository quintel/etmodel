D3.merit_order_price_curve =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    draw: ->
      @average = new ChartSerie(
        color: "#CC0000",
        label: I18n.t("output_element_series.merit_price_average")
      )

      @legendSeries = @model.non_target_series()
      @legendSeries.push(@average)

      @drawChart()
      @dateSelect.setVal(1)

      @drawLegend(@legendSeries, 1)

    averageData: ->
      values  = @prices[0].values.slice()

      color:  @average.attributes.color,
      label:  @average.attributes.label,
      key:    'average',
      values: values.map((price) ->
        x: price.x, y: d3.mean(values.map((price) -> price.y))
      )

    dataForChart: ->
      @prices = @model.non_target_series().map(@convertToDateRange)
      @prices.push(@averageData())
      @prices

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
        .attr('fill', 'none')
        .style("shape-rendering", "crispEdges")
        .style("stroke-dasharray", (d) ->
          if d.key == "average" then "3,3" else ""
        )

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
