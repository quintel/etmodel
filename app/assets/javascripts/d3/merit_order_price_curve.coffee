D3.merit_order_price_curve =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    margins:
      top: 20
      bottom: 20
      left: 70
      right: 20
      label_left: 25

    visibleData: =>
      @rawChartData
        .map (serie) =>
          $.extend({}, serie, values: MeritTransformator.transform(
            serie.values, this.dateSelect.toTransformOptions()
          ))

    draw: ->
      @average = new ChartSerie(
        color: "#CC0000",
        label: I18n.t("output_element_series.labels.merit_price_average")
      )

      super

      @drawOrRefreshLegend()

    averageData: (data) ->
      mean = d3.mean(_.find(data, (series) => series.is_target).values)

      color:  @average.attributes.color,
      label:  @average.attributes.label,
      key:    'average',
      values: Array.apply(null, Array(8760)).map(() => mean)

    dataForChart: ->
      # In this chart, we render target- and non-target- series the same. The
      # first (and ideally only) target series is used to create a new series
      # describing its average.
      data = @model.series.map(@getSerie)
      data.push(@averageData(data))
      data

    drawData: (xScale, yScale, line) ->
      @svg.selectAll('path.serie')
        .data(@chartData, (d) -> d.key)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr('class', 'serie line')
        .append('path')
        .attr('d', (data) -> line(data.values) )
        .attr('stroke', (data) -> data.color )
        .attr('stroke-width', 2)
        .attr('fill', 'none')
        .attr('opacity', (data) -> if data.values.length == 0 then 0 else 1)
        .style("shape-rendering", "crispEdges")
        .style("stroke-dasharray", (d) ->
          if d.key == "average" then "3,3" else ""
        )

    line: (xScale, yScale) ->
      d3.svg.line()
        .x((data) -> xScale(data.x))
        .y((data) -> yScale(data.y))
        .interpolate('step-after')

    main_formatter: () ->
      (value) -> "€/MWh #{Math.round(value)}"

    refresh: ->
      super

      @chartData = @convertData()

      xScale = @createTimeScale(@dateSelect.currentRange())
      yScale = @createLinearScale()
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      if @container_node().find("g.serie.line").length > 0
        @svg.selectAll('g.serie.line')
          .data(@chartData, (d) -> d.key)
          .select('path')
          .attr('d', (data) -> line(data.values || []) )
          .attr('opacity', (data) -> if data.values.length == 0 then 0 else 1)
      else
        @drawData(xScale, yScale, line)

      @drawOrRefreshLegend()

    drawOrRefreshLegend: ->
      legendSeries = @model.series.slice().filter((series) -> series.future_value().length > 0)
      legendSeries.push(@average)

      @drawLegend(legendSeries, 2)

    maxYvalue: ->
      d3.max(_.flatten(_.pluck(@visibleData(), 'values')))
