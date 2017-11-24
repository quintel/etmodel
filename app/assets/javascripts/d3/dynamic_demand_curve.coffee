D3.dynamic_demand_curve =
  View: class extends D3YearlyChartView
    initialize: ->
      D3YearlyChartView.prototype.initialize.call(this)

    can_be_shown_as_table: -> false

    margins :
      top: 20
      bottom: 50
      left: 65
      right: 20
      label_left: 30

    visibleData: ->
      super().filter (data) => !data.skip

    draw: ->
      super

      @serieGroup = @svg.append('g').classed('series', true)

    area: (xScale, yScale) ->
      d3.svg.area()
        .x((data) -> xScale(data.x))
        .y0((data) -> yScale(data.y0))
        .y1((data) -> yScale(data.y0 + data.y))
        .interpolate('monotone')

    line: (xScale, yScale) ->
      d3.svg.line()
        .x((data) -> xScale(data.x))
        .y((data) -> yScale(data.y))
        .interpolate('monotone')

    getStackedData: ->
      stacked: @stack(@chartData.filter((d) -> d.key != 'total_demand')),
      total: @chartData.filter((d) -> d.key == 'total_demand')

    getLegendSeries: ->
      legendSeries = []
      @series.forEach (serie) =>
         if _.find(serie.future_value(), (v) -> (v > 0))
           legendSeries.push(serie)

      legendSeries

    legend_click: (e) ->
      serie = @series.find((a) -> (a.id == e.attributes.id))

      if serie.attributes.is_target_line
        serie.set('skip', !serie.get('skip'))

        @refresh()

    initialDraw: (xScale, yScale, area, line) ->
      @svg.selectAll('g.serie')
        .data(@stackedData)
        .enter()
        .append('g')
        .attr('id', (data, index) -> "path_#{ index }")
        .attr('clip-path', "url(#clip_" + @chart_container_id() + ")")
        .attr("class", "serie")
        .append('path')
        .attr('class', (data) -> "area " + data.key)
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

      @svg.selectAll('g.serie-line')
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

      if @container_node().find("g.serie").length > 0
        serie = @svg.selectAll('g.serie')
          .data(@stackedData)
          .select('path.area')
          .attr('d', (data) -> area(data.values) )
          .attr('fill', (data) -> data.color )

        if @totalDemand.length > 0
          @svg.selectAll('g.serie-line')
            .style('opacity', 1)
            .data(@totalDemand)
            .select('path.line')
            .attr('d', (data) -> line(data.values) )
        else
          @svg.selectAll('g.serie-line').style('opacity', 0)

      else
        @initialDraw(xScale, yScale, area, line)
