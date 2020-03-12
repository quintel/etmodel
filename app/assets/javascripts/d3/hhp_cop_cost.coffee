D3.hhp_cop_cost =
  View: class extends D3ChartView
    MIN_COP = 1
    MAX_COP = 6

    COP_LIST = [MIN_COP]

    while COP_LIST[COP_LIST.length - 1] < MAX_COP
      COP_LIST.push(Math.round(10 * (COP_LIST[COP_LIST.length - 1] + 0.1)) / 10)

    initialize: ->
      D3ChartView.prototype.initialize.call(this)

    can_be_shown_as_table: -> false

    margins :
      top: 20
      bottom: 30
      left: 40
      right: 20
      label_left: 10

    draw: ->
      [@width, @height] = @available_size()
      @svg = @create_svg_container(@width, @height, @margins)

      xScale = @createXScale()
      yScale = @createYScale()
      line   = @line(xScale, yScale)

      @initialDraw(xScale, yScale, line)

    line: (xScale, yScale) ->
      d3.svg.line()
        .x((data) -> xScale(data.x))
        .y((data) -> yScale(data.y))
        .interpolate('cardinal')

    initialDraw: (xScale, yScale, line) ->
      @drawXAxis(xScale)
      @drawYAxis(yScale)

      @svg.selectAll('g.serie-line')
        .data(@dataForChart())
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

      @svg.selectAll('g.serie-circle')
        .data(@optimalThresholdData())
        .enter()
        .append('g')
        .attr('class', 'serie-circle')
        .append('circle')
        .attr('fill', (data) -> data.color )
        .attr('r', 9)
        .attr('cx', (data) -> xScale(data.x))
        .attr('cy', (data) -> yScale(data.y))

      $("#{@container_selector()} circle").qtip
        content:
          text:  -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom right'
          at: 'top center'

    refresh: ->
      xScale = @createXScale()
      yScale = @createYScale()
      line   = @line(xScale, yScale)

      @svg.select(".x_axis").call(@createXAxis(xScale))
      @svg.select(".y_axis").call(@createYAxis(yScale))

      @svg.selectAll('g.serie-line')
        .data(@dataForChart())
        .select('path.line')
        .attr('d', (data) -> line(data.values) )

      @svg.selectAll('g.serie-circle')
        .data(@optimalThresholdData())
        .select('circle')
        .attr('cx', (data) -> xScale(data.x))
        .attr('cy', (data) -> yScale(data.y))
        .attr('data-tooltip-text', (data) =>
          "COP #{Metric.round_number(data.x, 2)}, " +
          "#{Metric.round_number(data.y, 2)} #{@model.get('unit')} "
        )

      @drawLegend(@model.non_target_series().concat(@model.target_series()), 2)

    # Chart Data ---------------------------------------------------------------

    dataForChart: ->
      @model.target_series().map(@serieData)

    optimalThresholdData: ->
      @model.non_target_series().map((serie) ->
        [x, y] = serie.future_value()
        { x, y, color: serie.get('color') }
      )

    serieData: (serie) =>
      value = serie.future_value()

      values =
        if serie.get('gquery_key').match(/_electricity_cop/) && value
          (value / num for num in COP_LIST)
        else
          Array.apply(null, Array(COP_LIST.length)).map(-> value || 0)

      {
        color:     serie.get('color'),
        label:     serie.get('label'),
        key:       serie.get('gquery').get('key'),
        skip:      serie.get('skip'),
        is_target: serie.get('is_target_line'),
        values:    @convertValuesToXY(values)
      }

    convertValuesToXY: (values) =>
      values.map((value, valueIndex) => { x: COP_LIST[valueIndex], y: value })

    # Axes & Drawing -----------------------------------------------------------

    maxYValue: ->
      d3.max(
        @model.target_series().map(
          (serie) -> serie.future_value()
        )
      )

    createLinearScale: (minValue, maxValue, size) ->
      d3.scale.linear().domain([minValue, maxValue]).range([size, 0])

    createYScale: ->
      d3.scale.linear().domain([0, @maxYValue()]).range([@height, 0]).nice()

    createXScale: ->
      d3.scale.linear().domain([MAX_COP, MIN_COP]).range([@width, 0])

    # Draws the Y axis onto charts, configuring the scaling and grey grid lines.
    drawYAxis: (scale) ->
      yaxisg = @svg.append('g')
        .attr('class', 'y_axis inner_grid')
        .call(@createYAxis(scale))

      yaxisg.append("text")
        .attr("transform", "rotate(-90)")
        .attr("class", "unit")
        .attr("y", ((@margins.left / 2) * -1) - @margins.label_left)
        .attr("x", ((@height / 2) * -1) + 12)
        .attr("dy", ".71em")
        .attr("font-weight", "bold")
        .style("text-anchor", "end")
        .text(@model.get('unit'))

      scale

    createYAxis: (scale) ->
      d3.svg.axis().scale(scale)
        .orient('left')
        .ticks(6)
        .tickSize(-@width, 0)
        .tickFormat((v) => v)

    # Draws the X axis onto the charts, configuring the scaling and grey grid
    # lines.
    drawXAxis: (scale) ->
      xaxisg = @svg.append('g')
        .attr('class', 'x_axis inner_grid')
        .attr("transform", "translate(0,#{@height})")
        .call(@createXAxis(scale))

      xaxisg.append("text")
        .attr("class", "unit")
        .attr("font-weight", "bold")
        .style("text-anchor", "middle")
        .attr('x', scale(3.5))
        .attr('y', @margins.bottom)
        .text('COP')

      scale

    createXAxis: (scale) ->
      d3.svg.axis().scale(scale)
        .ticks(COP_LIST.length / 10)
        .tickSize(-@height, 0)
        .tickFormat((v) => v)

    drawLegend: (series, columns = 2) ->
      height = ((series.length + 1) / columns) * 15

      $(@container_selector()).find("div.legend").remove()

      @draw_legend(
        series:  series,
        width:   @width,
        columns: columns
      )
