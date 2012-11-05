D3.line =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      @key = @model.get 'key'
      @start_year = App.settings.get('start_year')
      @end_year = App.settings.get('end_year')
      @series = @model.series.models
      @initialize_defaults()

    can_be_shown_as_table: -> true

    outer_height: -> 400

    draw: =>
      margins =
        top: 20
        bottom: 200
        left: 20
        right: 40

      @width = 494 - (margins.left + margins.right)
      @height = 360 - (margins.top + margins.bottom)
      # height of the series section
      @series_height = 190
      @svg = d3.select("#d3_container_#{@key}")
        .append("svg:svg")
        .attr("height", @height + margins.top + margins.bottom)
        .attr("width", @width + margins.left + margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{margins.left}, #{margins.top})")

      @draw_legend
        svg: @svg
        series: @series
        width: @width
        vertical_offset: @series_height + 20
        columns: 2

      @x = d3.scale.linear().range([0, @width - 15])
        .domain([@start_year, @end_year])

      # show years at the corners
      @svg.selectAll('text.year')
        .data([App.settings.get('start_year'), App.settings.get('end_year')])
        .enter().append('svg:text')
        .attr('class', 'year')
        .attr("text-anchor", "middle")
        .text((d) -> d)
        .attr('x', (d, i) => if i == 0 then 0 else 430)
        .attr('y', @series_height + 16)

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 1])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 1])

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(4)
        .tickSize(-429, 10, 0)
        .orient("right")
        .tickFormat((x) => Metric.autoscale_value x, @model.get('unit'))
      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@width - 15}, 0)")
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
