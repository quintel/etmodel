D3.merit_order_hourly_supply =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    order: [
      'dispatchable',
      'must_run',
      'volatile'
    ]

    dataForChart: ->
      @series = @getSeries()

      stack = d3.layout.stack()
        .offset("zero")
        .values((d) -> d.values)

      stack(@series.map(@convertToDateRange))

    draw: ->
      @totalDemand = @model.target_series().map(@convertToDateRange)

      @drawChart()
      @dateSelect.setVal(1)

      @draw_legend(
        svg:     @create_svg_container(@width, 400, @margins),
        series:  @series,
        width:   @width,
        columns: 2
      )

      defs = @svg.append('defs')
      defs.append('clipPath')
          .attr('id', 'clip')
          .append('rect')
          .attr('width', @width)
          .attr('height', @height)

    getSeries: ->
      order = @order

      _.filter(@model.non_target_series(), (serie) ->
        d3.max(serie.future_value()) > 0
      ).sort((a,b) ->
        order.indexOf(a.get('group')) - order.indexOf(b.get('group'))
      )

    drawData: (xScale, yScale) ->
      area = @area(xScale, yScale)
      line = @line(xScale, yScale)

      @svg.selectAll('path.serie')
        .data(@chartData)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr('clip-path', 'url(#clip)')
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
      xScale = @createTimeScale(@dateSelect.getCurrentRange())
      yScale = @createLinearScale()
      area   = @area(xScale, yScale)
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      @chartData.map(LoadSlicer.slice.bind(this))
      @totalDemand.map(LoadSlicer.slice.bind(this))

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
      result = 0

      for chart in @chartData
        result += d3.max(chart.values.map((point) -> point.y))

      [result]
