D3.merit_order_hourly_flexibility =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    calculateOffset: (data) ->
      @totalDemand[0].values.map((point) -> point.y)

    dataForChart: ->
      @totalDemand = @model.target_series().map(@convertToDateRange)
      @series = @model.non_target_series()

      @stack = d3.layout.stack()
        .offset(@calculateOffset.bind(this))
        .values((d) -> d.values)

      @stack(@series.map(@convertToDateRange))

    filterYValue: (value) ->
      if this.attributes.gquery_key == 'total_demand' then value else -value

    draw: ->
      @drawChart()
      @dateSelect.setVal(1)

      @drawLegend(@series.concat(@model.target_series()))

      defs = @svg.append('defs')
      defs.append('clipPath')
          .attr('id', "clip_" + @chart_container_id())
          .append('rect')
          .attr('width', @width)
          .attr('height', @height)

    drawData: (xScale, yScale) ->
      area = @area(xScale, yScale)
      line = @line(xScale, yScale)

      @svg.selectAll('path.serie')
        .data(@chartData)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr('clip-path', "url(#clip_" + @chart_container_id() + ")")
        .attr("class", "serie")
        .append('path')
        .attr('class', 'area')
        .attr('d', (data) -> area(data.values) )
        .attr('fill', (data) -> data.color )

      @svg.selectAll('path.serie')
        .data(@totalDemand)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr("class", "serie-line")
        .append('path')
        .attr('class', 'line')
        .attr('d', (data) -> line(data.values) )
        .attr('stroke', (data) -> data.color )
        .attr('stroke-width', 2)
        .attr('fill', 'none')

    updateData: (xScale, yScale) ->
      @totalDemand = new MeritTransformator(this, @totalDemand).transform()
      @chartData   = new MeritTransformator(this, @chartData).transform()

      xScale = @createTimeScale(@dateSelect.getCurrentRange())
      yScale = @createLinearScale()
      area   = @area(xScale, yScale)
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      @svg.selectAll('g.serie')
        .data(@chartData)
        .select('path.area')
        .attr('d', (data) -> area(data.values) )

      @svg.selectAll('g.serie-line')
        .data(@totalDemand)
        .select('path.line')
        .attr('d', (data) -> line(data.values) )

    area: (xScale, yScale) ->
      d3.svg.area()
        .x((data) -> xScale(data.x))
        .y0((data) -> yScale(data.y0))
        .y1((data) -> yScale(data.y0 + data.y))
        .interpolate('cardinal')

    line: (xScale, yScale) ->
      d3.svg.line()
        .x((data) -> xScale(data.x))
        .y((data) -> yScale(data.y))
        .interpolate('cardinal')

    maxYvalue: ->
      last = @chartData[@chartData.length - 1]

      d3.max(last.values.map((point) -> point.y + point.y0))
