D3.co2_emissions =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @series = @model.series.models

    can_be_shown_as_table: -> true

    margins:
      top: 20
      bottom: 35
      left: 30
      right: 40

    # This method is called right before rendering because the series are
    # added when the JSON request is complete, ie after the initialize method
    #
    setup_series: =>
      @serie_1990   = @series[0]
      @serie_value  = @series[1]
      @serie_target = @series[2]

    draw: =>
      @setup_series()

      [@width, @height] = @available_size()

      legend_height = @legend_cell_height
      legend_margin = 20
      @series_height = @height - legend_height - legend_margin

      @svg = @create_svg_container @width, @height, @margins

      # Ugly stuff. Check the db to see which series have been defined.
      # Since this chart is very specific the series could actually be
      # hard-coded
      series_for_legend = [@serie_1990, @serie_value]

      @draw_legend
        svg: @svg
        series: series_for_legend
        width: @width
        vertical_offset: @series_height + legend_margin
        columns: 2

      @x = d3.scale.ordinal().rangeRoundBands([0, @width - 25])
        .domain([1990, @start_year, @end_year])
      @x_axis = d3.svg.axis()
        .scale(@x)
        .tickSize(2, 2, 0)
        .orient("bottom")
      @svg.append("svg:g")
        .attr("class", "x_axis inner_grid")
        .attr("transform", "translate(0, #{@series_height})")
        .call(@x_axis)

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 1])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 1])

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(5)
        .tickSize(-(@width - 25), 10, 0)
        .orient("right")
        .tickFormat(@main_formatter())
      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@width - 25}, 0)")
        .call(@y_axis)

      # there we go
      @block_width = @x.rangeBand() * 0.5
      rect = @svg.selectAll('rect.serie')
        .data(@prepare_data(), (s) -> s.id)
        .enter().append('svg:rect')
        .attr('class', 'serie')
        .attr("width", @block_width)
        .attr('x', (s) => @x(s.x) + @block_width / 2)
        .attr('y', @series_height)
        .style('fill', '#333')
        .style('opacity', 0.8)

      $("#{@container_selector()} rect.serie").qtip
        content: -> $(this).attr('data-tooltip')
        position:
          my: 'bottom center'
          at: 'top center'

      # target lines
      @svg.selectAll('rect.target_line')
        .data([@serie_target], (d) -> d.get 'gquery_key')
        .enter()
        .append('svg:rect')
        .attr('class', 'target_line')
        .style('fill', '#ff0000')
        .attr('height', 2)
        .attr('width', @block_width * 1.2)
        .attr('x', @x(@end_year) + @block_width * 0.4)
        .attr('y', @series_height)
        .style('opacity', 0.0)

    max_series_value: ->
      _.max([
        @serie_1990.safe_future_value(),
        @serie_value.safe_present_value(),
        @serie_value.safe_future_value(),
        @serie_target.safe_future_value()
      ])

    refresh: =>
      # calculate tallest column
      tallest = @max_series_value()

      # update the scales as needed
      @y = @y.domain([0, tallest])
      @inverted_y = @inverted_y.domain([0, tallest])

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      # let the stack method filter the data again, adding the offsets as needed
      @svg.selectAll('rect.serie')
        .data(@prepare_data(), (s) -> s.id)
        .transition()
        .attr('y', (d) => @series_height - @y(d.y))
        .attr('height', (d) => @y(d.y))
        .attr("data-tooltip", (d) => @main_formatter()(d.y))

      # move the target lines
      @svg.selectAll('rect.target_line')
        .data([@serie_target], (d) -> d.get 'gquery_key')
        .transition()
        .attr('y', (d) => @series_height - (@y d.safe_future_value()))
        .style('opacity', (d) -> if d.future_value() == null then 0.0 else 0.8)


    prepare_data: =>
      [
        {id: 'co2_1990',    x: 1990,        y: @serie_1990.safe_future_value()},
        {id: 'co2_present', x: @start_year, y: @serie_value.safe_present_value()},
        {id: 'co2_future',  x: @end_year,   y: @serie_value.safe_future_value()}
      ]

    # This chart has to override the standard render_as_table method
    #
    render_as_table: =>
      # return false
      @clear_container()
      @setup_series()

      formatter = @main_formatter(precision: 4)

      unit = @model.get('unit')
      raw_target = @serie_target.future_value()
      target = if raw_target?
        target = formatter(raw_target)
      else
        '-'
      html = "
        <table class='chart'>
          <thead>
            <tr>
              <th>1990</td>
              <th>#{@start_year}</td>
              <th>#{@end_year}</td>
              <th>Target</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>#{formatter(@serie_1990.safe_future_value())}</td>
              <td>#{formatter(@serie_value.safe_present_value())}</td>
              <td>#{formatter(@serie_value.safe_future_value())}</td>
              <td>#{target}</td>
            </tr>
          </tbody>
        </table>
      "
      @container_node().html(html)
