D3.electricity_network_load =
D3.electricity_lv_network_load =
D3.electricity_mv_network_load =
D3.electricity_hv_network_load =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    margins:
      top: 20
      bottom: 20
      left: 75
      right: 20
      label_left: 20

    downsampleWith: 'max'

    draw: ->
      @legendSeries = @model.non_target_series()

      super

      @drawLegend(@legendSeries, 1)

    drawData: (chart_data, xScale, yScale) ->
      line_function = @line(xScale, yScale)

      @svg.selectAll('path.serie')
        .data(chart_data)
        .enter()
        .append('g')
        .attr('class', 'serie')
        .attr('id', (data, index) -> "path_#{ index }")
        .append('path')
        .attr('d', (data) -> line_function(data.values))
        .attr('stroke', (data) -> data.color )
        .attr('class', (data) -> data.key)
        .attr('stroke-width', 2)
        .attr('fill', 'none')

      @svg.append('rect').attr('class', 'subzero')

    line: (xScale, yScale) ->
      d3.svg.line()
        .x((data) -> xScale(data.x))
        .y((data) -> yScale(data.y))
        .interpolate('monotone')

    refresh: ->
      super

      data = @convertToXY(@visibleData())

      xScale = @createTimeScale(@dateSelect.getCurrentRange())
      yScale = @createLinearScale()

      @svg.select(".x_axis").call(@createTimeAxis(xScale))
      @svg.select(".y_axis").call(@createLinearAxis(yScale))

      if @container_node().find("g.serie").length > 0
        line_function = @line(xScale, yScale)

        serie = @svg.selectAll('g.serie')
          .data(data)
          .select('path')
          .attr('d', (data) -> line_function(data.values) )
      else
        @drawData(data, xScale, yScale)

      @svg.selectAll('rect.subzero')
        .attr('height', (s) => yScale(yScale.domain()[0]) - yScale(0))
        .attr('y', (s) => yScale(0))
        .attr('width', @width)

    visibleData: ->
      data = super()

      data.forEach (serie) ->
        if serie.key.match(/supply/)
          serie.values = serie.values.map (v) -> -v

      data

    yValueExtent: ->
      [min, max] = d3.extent(_.flatten(
        @visibleData().map((serie) -> d3.extent(serie.values))
      ))

      min = 0.0 if min > 0
      max = 0.0 if max < 0

      if min < 0 && max > 0
        if Math.abs(min) > max
          [min, -min]
        else
          [-max, max]
      else
        [min, max]

    maxYvalue: ->
      Math.max(@yValueExtent().map(Math.abs)...)

    createLinearScale: ->
      d3.scale.linear().domain(@yValueExtent()).range([@height, 0]).nice()
