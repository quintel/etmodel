D3.scatter =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      @key = @model.get 'key'
      @series = @model.series.models
      @initialize_defaults()

    can_be_shown_as_table: -> false

    outer_height: -> 400

    draw: =>
      margins =
        top: 20
        bottom: 200
        left: 40
        right: 10

      @width = 494 - (margins.left + margins.right)
      @height = 360 - (margins.top + margins.bottom)
      # height of the series section
      @series_height = 190
      @svg = d3.select(@container_selector())
        .append("svg:svg")
        .attr("height", @height + margins.top + margins.bottom)
        .attr("width", @width + margins.left + margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{margins.left}, #{margins.top})")

      @draw_legend
        svg: @svg
        series: @series
        width: @width
        vertical_offset: @series_height + 35
        columns: 2

      @x = d3.scale.linear().range([0, @width - 15])
        .domain([0, 100])
      @y = d3.scale.linear().range([0, @series_height])
        .domain([0, 100])
      @inverted_y = d3.scale.linear().range([@series_height, 0])
        .domain([0, 100])

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(4)
        .tickSize(-(@width - 15), 0)
        .orient("left")
      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(15, 0)")
        .call(@y_axis)
      @x_axis = d3.svg.axis()
        .scale(@x)
        .ticks(4)
        .tickSize(-@series_height, 0)
        .orient("bottom")
      @svg.append("svg:g")
        .attr("class", "x_axis inner_grid")
        .attr("transform", "translate(15, #{@series_height})")
        .call(@x_axis)

      # rotated labels
      @svg.append('svg:g')
        .attr('transform', "translate(#{(@width - 15) / 2}, #{@series_height + 25})")
        .append('text')
        .attr('class', 'label')
        .attr("text-anchor", "middle")
        .text(@x_axis_unit())
      @svg.append('svg:g')
        .attr('transform', "rotate(270) translate(#{-@series_height / 2}, -15)")
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
      @x = @x.domain([0, @max_x()])
      @y = @y.domain([@max_y(), 0])
      @inverted_y = @inverted_y.domain([0, @max_y()])

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

