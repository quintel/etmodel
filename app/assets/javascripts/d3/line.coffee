D3.line =
  View: class extends D3ChartView
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @series = @model.series.models

    can_be_shown_as_table: -> true

    margins :
      top: 20
      bottom: 50
      left: 20
      right: 70

    draw: =>
      [@width, @height] = @available_size()

      legend_columns = 2
      legend_rows = @model.series.length / legend_columns
      legend_margin = 20

      @series_height = @height - legend_margin

      @svg = @create_svg_container @width, @series_height, @margins

      @draw_legend
        svg: @svg
        series: @series
        width: @width
        vertical_offset: @series_height + legend_margin
        columns: legend_columns

      @x = d3.scale.linear().range([0, @width])
        .domain([@start_year, @end_year])

      # show years at the corners
      @svg.selectAll('text.year')
        .data([@start_year, @end_year])
        .enter().append('svg:text')
        .attr('class', 'year')
        .attr("text-anchor", "middle")
        .text((d) -> d)
        .attr('x', (d, i) => if i == 0 then 0 else @width)
        .attr('y', @series_height + 16)

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 1])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 1])

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(4)
        .tickSize(-@width, 10, 0)
        .orient("right")
        .tickFormat((x) => Metric.autoscale_value x, @model.get('unit'))
      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@width}, 0)")
        .call(@y_axis)

      # draw lines
      @line = d3.svg.line()
        .x((d) => @x d[0])
        .y((d) => @y d[1])

      @svg.selectAll('path.serie')
        .data(@prepare_data(), (d) -> d.key)
        .enter()
        .append('path')
        .attr('class', 'serie')
        .attr('d', (d) => @line d.values)
        .style('stroke', (d) -> d.color || '#000')

    refresh: =>
      # update the scales as needed
      max_value = @max_value()
      @y = @y.domain([max_value, 0])
      @inverted_y = @inverted_y.domain([0, max_value])

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      @svg.selectAll('path.serie')
        .data(@prepare_data(), (d) -> d.key)
        .transition()
        .attr('d', (d) => @line d.values)
        .style('opacity', (d) -> if d.disabled then 0 else 1)

    max_value: =>
      d3.max(_.flatten @model.value_pairs())

    prepare_data: =>
      _.map @series, (s) =>
        key: s.get 'gquery_key'
        color: s.get 'color'
        disabled: (s.get('is_target_line') && (s.future_value() == null))
        values: [
          [@start_year, s.safe_present_value()],
          [@end_year, s.safe_future_value()]
        ]
