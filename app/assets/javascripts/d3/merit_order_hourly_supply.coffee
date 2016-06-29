D3.merit_order_hourly_supply =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    dataForChart: ->
      @series = @model.target_series().concat(@getSeries())
      @series.map(@getSerie)

    filterYValue: (value) ->
      if this.key == 'households_flexibility_p2p_electricity'
        if value > 0 then value else 0
      else
        value

    draw: ->
      @drawChart()

      @dateSelect.setVal(1)

      @drawLegend(@getLegendSeries())

      defs = @svg.append('defs')
      defs.append('clipPath')
          .attr('id', "clip_" + @chart_container_id())
          .append('rect')
          .attr('width', @width)
          .attr('height', @height)

    setStackedData: ->
      @chartData = @convertData()

      @stack = d3.layout.stack()
        .offset("zero")
        .values((d) -> d.values)

      @stackedData = @stack(@chartData[1..@chartData.length])
      @totalDemand = [@chartData[0]]

    getSpikiness: (serie) ->
      values = serie.future_value()

      Math.abs((d3.max(values) - d3.min(values)) / d3.sum(values))

    getLegendSeries: ->
      legendSeries = []
      @series.forEach (serie) =>
         if serie.future_value().find((v) -> (v > 0))
           legendSeries.push(serie)

      legendSeries

    getSeries: ->
      @model.non_target_series().sort (a, b) =>
        @getSpikiness(a) > @getSpikiness(b)

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
        .attr('data-tooltip-text', (d) -> d.label)

      $("#{@container_selector()} path.area").qtip
        content:
          text:  -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom right'
          at: 'top center'

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

    refresh: (xScale, yScale) ->
      super

      @setStackedData()
      @drawLegend(@getLegendSeries())

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
          .attr('d', (data) -> area(data.values) )
          .attr('fill', (data) -> data.color )

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

      @rawChartData[1..@rawChartData.length].map (chart) ->
        chart.values.forEach (value, index) ->
          if result[index]
            result[index] += value
          else
            result[index] = value

      d3.max(result)
