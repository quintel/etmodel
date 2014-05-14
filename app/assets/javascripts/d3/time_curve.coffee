D3.time_curve = View: class extends D3ChartView
  legendColumns: 2
  can_be_shown_as_table: -> true
  margins: { top: 20, bottom: 50, left: 50, right: 20 }

  # Uses the model to draw the data from ETEngine in the form of a line chart.
  draw: =>
    [ @width, @height ] = @available_size()
    @svg                = @create_svg_container(@width, @height, @margins)
    chartData           = @dataForChart()

    xScale = @drawXAxis()
    yScale = @drawYAxis()

    @drawLegends(chartData)
    @drawData(chartData, xScale, yScale)

  # Refreshes the chart as data changes.
  #
  # Time curve charts are not expected to ever change during the lifetime of a
  # scenario, since the data is static (and lives in ETSource). Therefore,
  # refresh is not implemented.
  refresh: =>
    # noop

  render_as_table: ->
    @clear_container()

    table  = $('<table class="chart autostripe" cellspacing="0"></table>')
    thead  = $('<thead></thead>')
    header = $('<tr></tr>').append($('<td></td>'))
    body   = $('<tbody></tbody>')
    tfoot  = $('<tfoot><tr><td></td></tr></tfoot>')

    for series in @model.non_target_series()
      header.append($('<th></th>').text(series.get('label')))
      tfoot.find('tr').append($('<td></td>'))

    for year in @allAxisValues('x')
      body.append(row = $('<tr></tr>'))
      row.append($('<td style="font-weight: bold"></td>').text(year))

      for series in @model.non_target_series()
        sValues = series.future_value()

        if sValues.hasOwnProperty("#{ year }")
          row.append($('<td></td>').html(
            Metric.autoscale_value(sValues["#{ year }"], @model.get('unit'))))
        else
          row.append($('<td>&ndash;</td>'))

    @container_node()
      .removeClass('chart_canvas')
      .addClass('table_canvas')
      .append(table.append(thead.append(header)).append(body).append(tfoot))

  # Draws the X axis onto the charts, configuring the scaling and grey grid
  # lines.
  drawXAxis: ->
    [min, ..., max] = @allAxisValues('x')

    height = @height - @legendHeight()
    scale  = d3.scale.linear().domain([min, max]).range([0, @width])

    axis = d3.svg.axis()
      .tickFormat(_.identity).tickSize(-height, 0)
      .scale(scale).orient('bottom')

    @svg.append('g')
      .attr('class', 'x_axis inner_grid')
      .attr("transform", "translate(0,#{ height })")
      .call(axis)
      .call((selection) -> selection.selectAll('text').attr('y', 7))

    scale

  # Draws the Y axis onto the charts, configuring the scaling and grey grid
  # lines.
  drawYAxis: ->
    max    = _.last(@allAxisValues('y'))
    height = @height - @legendHeight()
    scale  = d3.scale.linear().domain([0, max]).range([height, 0]).nice()

    format = (value) =>
      if value != 0 then Metric.autoscale_value value, @model.get('unit')

    axis = d3.svg.axis()
      .tickFormat(format).ticks(7).tickSize(-@width, 0)
      .scale(scale).orient('left')

    @svg.append('g')
      .attr('class', 'y_axis inner_grid')
      .call(axis)

    scale

  # Given the chart data, draws each serie onto the chart.
  drawData: (chart_data, xScale, yScale) ->
    line_function = d3.svg.line()
      .x((data) -> xScale(data.x))
      .y((data) -> yScale(data.y))
      .interpolate('monotone')

    @svg.selectAll('path.serie')
      .data(chart_data)
      .enter()
      .append('g')
      .attr('id', (data, index) -> "path_#{ index }")
      .append('path')
      .attr('d', (data) -> line_function(data.values) )
      .attr('stroke', (data) -> data.color )
      .attr('stroke-width', 2)
      .attr('fill', 'none')

  # Given the chart data, draws the legend beneath the chart.
  drawLegends: (chart_data) ->
    seriesHeight  = @height - @legendHeight()
    columnWidth   = @width / @legendColumns
    cellHeight    = @legend_cell_height

    legend = @svg.append('g')
      .attr('class', 'legend')
      # "30" is padding to prevent overlapping the x axis labels.
      .attr('transform', "translate(0, #{ seriesHeight + 30 })")
      .append('svg')

    # Colour boxes.
    legend.selectAll('rect')
      .data(chart_data)
      .enter()
      .append('rect')
      .attr('x', (data, index) -> (index % 2) * columnWidth)
      .attr('y', (data, index) -> Math.floor(index / 2) * cellHeight)
      .attr('width', '10')
      .attr('height', '10')
      .attr('fill', (data) -> data.color)

    # Series names.
    legend.selectAll('text')
      .data(chart_data)
      .enter()
      .append('text')
      .attr('class', 'legend_label')
      .attr('x', (data, index) -> (index % 2) * columnWidth + 15)
      .attr('y', (data, index) -> Math.floor(index / 2) * cellHeight + 10)
      .text((data) -> data.label)

  # Converts the data from the API into a form useable by D3.
  #
  # Returns an object.
  dataForChart: ->
    @model.non_target_series().map (serie) ->
      color:  serie.get('color'),
      label:  serie.get('label'),
      values:  _.map(serie.future_value(),
                    (value, year) -> { x: parseInt(year, 10), y: value })

  # Calculates the height necessary to draw the legend.
  legendHeight: ->
    @legend_cell_height *
      Math.ceil(@model.non_target_series().length / @legendColumns) # rows

  # Given an axis, "x" or "y", returns an array containing all unique values in
  # the axis sorted in ascending order.
  allAxisValues: (axis) ->
    extractor = if axis is 'x' then _.keys else _.values

    _.chain(@model.non_target_series())
      .map((serie) -> extractor(serie.future_value())).flatten()
      .map((value) -> parseFloat(value)).uniq()
      .sortBy(_.identity)
      .value()
