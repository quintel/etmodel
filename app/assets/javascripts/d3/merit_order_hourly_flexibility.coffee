D3.merit_order_hourly_flexibility =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    dataForChart: ->
      @series = @model.target_series().concat(@model.non_target_series())
      @series.map(@getSerie)

    calculateOffset: (data) ->
      @chartData[0].values.map((point) -> point.y)

    filterYValue: (value) ->
      if this.key == 'total_demand' then value else -value

    draw: ->
      @drawChart()
      @drawLegend(@series)

      defs = @svg.append('defs')
      defs.append('clipPath')
          .attr('id', "clip_" + @chart_container_id())
          .append('rect')
          .attr('width', @width)
          .attr('height', @height)

    setStackedData: ->
      @chartData = @convertData()

      @stack = d3.layout.stack()
        .offset(@calculateOffset.bind(this))
        .values((d) -> d.values)

      @stackedData = @stack(@chartData[1..@chartData.length])
      @totalDemand = [@chartData[0]]

    drawData: (xScale, yScale, area, line) ->
      @svg.selectAll('path.serie')
        .data(@stackedData)
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
        .attr('clip-path', "url(#clip_" + @chart_container_id() + ")")
        .attr("class", "serie-line")
        .append('path')
        .attr('class', 'line')
        .attr('d', (data) -> line(data.values) )
        .attr('stroke', (data) -> data.color )
        .attr('stroke-width', 2)
        .attr('fill', 'none')

    refresh: ->
      super

      @setStackedData()

      xScale = @createTimeScale(@dateSelect.getCurrentRange())
      yScale = @createLinearScale()
      area   = @area(xScale, yScale)
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      if @container_node().find("g.serie-line").length > 0
        @svg.selectAll('g.serie')
          .data(@stackedData)
          .select('path.area')
          .attr('fill', (data) -> data.color )
          .attr('d', (data) -> area(data.values) )

        @svg.selectAll('g.serie-line')
          .data(@totalDemand)
          .select('path.line')
          .attr('d', (data) -> line(data.values) )

      else
        @drawData(xScale, yScale, area, line)

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
      result = []

      @rawChartData.map (chart) ->
        chart.values.forEach (value, index) ->
          if result[index]
            result[index] += Math.abs(value)
          else
            result[index] = Math.abs(value)

      d3.max(result)
