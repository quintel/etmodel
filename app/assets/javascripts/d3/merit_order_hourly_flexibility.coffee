D3.merit_order_hourly_flexibility =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    draw: ->
      @drawChart()

      defs = @svg.append('defs')
      defs.append('clipPath')
          .attr('id', 'clip')
          .append('rect')
          .attr('width', @width)
          .attr('height', @height)

    dataForChart: ->
      stack = d3.layout.stack()
        .offset("zero")
        .values((d) -> d.values)

      #@model.non_target_series().map (serie) ->
      #  color:  serie.get('color'),
      #  label:  serie.get('label'),
      #  values:  _.map(serie.future_value(),
      #                (value, hour) -> {
      #                  x: new Date(hour * 60 * 60 * 1000),
      #                  y: value })

      fakeData = [
        {key: "a", color: "#990", values: []},
        {key: "b", color: "#905", values: []},
        {key: "c", color: "#590", values: []}
      ]

      for i in [0...3]
        for j in [0...8760]
          fakeData[i].values.push(
            y: Math.sin(j + 1) / 10, x: new Date(j * 60 * 60 * 1000)
          )

      stack(fakeData)

    drawData: (xScale, yScale) ->
      area = @area(xScale, yScale)

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

    updateData: (xScale, yScale) ->
      xScale = @createTimeScale(@dateSelect.getCurrentRange())
      yScale = @createLinearScale()
      area   = @area(xScale, yScale)

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      @chartData.map(LoadSlicer.slice.bind(this))

      @svg.selectAll('g.serie')
        .data(@chartData)
        .select('path.area')
        .attr('d', (data) -> area(data.values) )

    area: (xScale, yScale) ->
      d3.svg.area()
        .x((data) -> xScale(data.x))
        .y0((data) -> yScale(data.y0))
        .y1((data) -> yScale(data.y0 + data.y))
        .interpolate('step-after')

    allAxisValues: (axis) ->
      result = 0

      for chart in @chartData
        result += d3.max(chart.values.map((point) -> point[axis]))

      [result]

    refresh: ->
