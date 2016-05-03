D3.merit_order_price_curve =
  View: class extends D3ChartView
    initialize: ->
      D3ChartView.prototype.initialize.call(this)

    margins:
      top: 20
      bottom: 20
      left: 60
      right: 20

    draw: ->
      [@width, @height] = @available_size()

      @svg        = @create_svg_container @width, @height, @margins
      @chartData  = @dataForChart()

      @dateSelect = new D3ChartDateSelect(@container_node(), @chartData[0].values.length)
      @dateSelect.draw(@updateData.bind(this))

      @xScale     = @drawXAxis()
      @yScale     = @drawYAxis()

      @drawData(@xScale, @yScale)

    dataForChart: ->
      @model.non_target_series().map (serie) ->
        color:  serie.get('color'),
        label:  serie.get('label'),
        values:  _.map(serie.future_value(),
                      (value, hour) -> {
                        x: new Date(hour * 60 * 60 * 1000),
                        y: value })

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

    createLinearScale: ->
      maxY = d3.max(@allAxisValues('y'))

      d3.scale.linear().domain([0, maxY]).range([@height, 0]).nice()

    createLinearAxis: (scale) ->
      d3.svg.axis().scale(scale).orient('left').ticks(7).tickSize(-@width, 0)

    createTimeScale: (domain) ->
      d3.time.scale.utc().range([0, @width]).domain(domain)

    createTimeAxis: (scale) ->
      formatting = (if @dateSelect.isWeekly() then "%b %d" else "%b")
      format = d3.time.format.utc(formatting)

      d3.svg.axis().scale(scale).orient('bottom').tickFormat(format).ticks(7)

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

    allAxisValues: (axis) ->
      @chartData[0].values.map((point) -> point[axis])

    refresh: ->
      @chartData = @dataForChart()
      @updateData()

    updateData: () ->
      xScale = @createTimeScale(@dateSelect.getCurrentRange())
      yScale = @createLinearScale()
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      @chartData.map(LoadSlicer.slice.bind(this))

      @svg.selectAll('g.serie')
        .data(@chartData)
        .select('path.line')
        .attr('d', (data) -> line(data.values) )
