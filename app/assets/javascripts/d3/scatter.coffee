D3.scatter =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @series = @model.series.models

    can_be_shown_as_table: -> false

    margins:
      top: 20
      bottom: 20
      left: 50
      right: 10

    draw: =>
      [@width, @height] = @available_size()

      legend_columns = 2
      legend_rows = @series.length / legend_columns
      legend_height = legend_rows * @legend_cell_height
      legend_margin = 30

      @series_height = @height - legend_height - legend_margin
      @series_width = @width - 20

      @svg = @create_svg_container @width, @height, @margins

      @draw_legend
        svg: @svg
        series: @series
        width: @width
        vertical_offset: @series_height + legend_margin
        columns: legend_columns

      @x = d3.scale.linear().range([0, @series_width])
        .domain([0, 100])
      @y = d3.scale.linear().range([0, @series_height])
        .domain([0, 100])
      @inverted_y = d3.scale.linear().range([@series_height, 0])
        .domain([0, 100])

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(4)
        .tickSize(-@series_width, 0)
        .orient("left")
      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .call(@y_axis)
      @x_axis = d3.svg.axis()
        .scale(@x)
        .ticks(4)
        .tickSize(-@series_height, 0)
        .orient("bottom")
      @svg.append("svg:g")
        .attr("class", "x_axis inner_grid")
        .attr("transform", "translate(0, #{@series_height})")
        .call(@x_axis)

      # rotated labels
      @svg.append('svg:g')
        .attr('transform', "translate(#{(@series_width) / 2}, #{@series_height + 25})")
        .append('text')
        .attr('class', 'label')
        .attr("text-anchor", "middle")
        .text(@x_axis_unit())
      @svg.append('svg:g')
        .attr('transform', "rotate(270) translate(#{-@series_height / 2}, -30)")
        .append('text')
        .attr('class', 'label')
        .attr("text-anchor", "middle")
        .text(@y_axis_unit())

      @svg.selectAll('circle.serie')
        .data(@series, (d) -> d.get 'gquery_key')
        .enter()
        .append('circle')
        .attr('class', 'serie')
        .attr('r', 7)
        .attr('cx', (d) => @x d.safe_x())
        .attr('cy', (d) => @y d.safe_y())
        .style('fill', (d) -> d.get('color') || 'steelblue')
        .attr('data-tooltip-title', (d) -> d.get 'label')

      $("#{@container_selector()} circle.serie").qtip
        content:
          title: -> $(this).attr('data-tooltip-title')
          text: -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom right'
          at: 'top center'

    refresh: =>
      @x.domain([0, @max_x()])
      @y.domain([@max_y(), 0])
      @inverted_y.domain([0, @max_y()])

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))
      @svg.selectAll(".x_axis").transition().call(@x_axis.scale(@x))

      @svg.selectAll('circle.serie')
        .data(@series, (d) -> d.get 'gquery_key')
        .transition()
        .attr('cx', (d) => @x d.safe_x())
        .attr('cy', (d) => @y d.safe_y())
        .attr('data-tooltip-text', (d) =>
          "<table>
            <tr><td>#{@x_axis_unit()}</td><td>#{Metric.autoscale_value d.safe_x()}</td></tr>
            <tr><td>#{@y_axis_unit()}</td><td>#{Metric.autoscale_value d.safe_y()}</td></tr>
          </table>
          "
        )

    max_x: => d3.max(_.map @series, (s) -> s.result()[0])
    max_y: => d3.max(_.map @series, (s) -> s.result()[1])

    x_axis_unit: => @model.get('unit').split(';')[0]
    y_axis_unit: => @model.get('unit').split(';')[1]

