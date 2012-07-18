D3.stacked_bar =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      @key = @model.get 'key'
      @initialize_defaults()

    draw: =>
      margins =
        top: 40
        bottom: 100
        left: 30
        right: 30

      @width = (@container_node().width()   || 490) - (margins.left + margins.right)
      @height = (@container_node().height() || 402) - (margins.top + margins.bottom)
      @svg = d3.select("#d3_container_#{@key}")
        .append("svg:svg")
        .attr("height", @height + margins.top + margins.bottom)
        .attr("width", @width + margins.left + margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{margins.left}, #{margins.top})")

      # add legend
      legend = @svg.append('svg:g')
        .attr("transform", "translate(0,200)")
        .selectAll("svg.legend")
        .data(@model.series.models)
        .enter()
        .append("svg:g")
        .attr("class", "legend")
        .attr("transform", (d, i) ->
          "translate(#{100 * (i % 4) + 10}, #{Math.floor(i / 4) * 20})")
        .attr("height", 30)
        .attr("width", 90)
      legend.append("svg:rect")
        .attr("width", 10)
        .attr("height", 10)
        .attr("fill", (d) => d.get 'color')
      legend.append("svg:text")
        .text((d) -> d.get 'label')
        .attr("x", 15)
        .attr("y", 8)

      # the stack method will filter the data and calculate the offset for every
      # item
      @stack_method = d3.layout.stack().offset('zero')
      stacked_data = _.flatten @stack_method(@prepare_data())

      @x = d3.scale.ordinal().rangeRoundBands([0, @width])
        .domain([App.settings.get('start_year'), App.settings.get('end_year')])

      # show years
      @svg.selectAll('text.year')
        .data([App.settings.get('start_year'), App.settings.get('end_year')])
        .enter().append('svg:text')
        .attr('class', 'year')
        .text((d) -> d)
        .attr('x', (d) => @x(d))
        .attr('y', 175)
        .attr('dx', 45)

      @y = d3.scale.linear().range([0, @height]).domain([0, 7])
      @inverted_y = d3.scale.linear().range([@height, 0]).domain([0, 7])

      rect = @svg.selectAll('rect.serie')
        .data(stacked_data, (s) -> s.id)
        .enter().append('svg:rect')
        .attr('class', 'serie')
        .attr("width", @x.rangeBand() * 0.5)
        .attr('x', 0)
        .attr('y', 0)
        .style('fill', (d) => d.color)

      # draw a nice axis
      @y_axis = d3.svg.axis().scale(@inverted_y).ticks(4).orient("right")
        .tickFormat((x) => Metric.autoscale_value x, @model.get('unit'))
      @svg.append("svg:g")
        .attr("class", "y_axis")
        .attr("transform", "translate(#{@width - 25}, 0)")
        .call(@y_axis)

      # target lines
      # An ugly thing in the target lines is the extra attribute called "target
      # line position". If set to 1 then the target line must be shown on the
      # first column only, if 2 only on the 2nd. The CO2 chart is different, too
      @svg.selectAll('rect.target_line')
        .data(@model.target_series(), (d) -> d.get 'gquery_key')
        .enter()
        .append('svg:rect')
        .attr('class', 'target_line')
        .style('fill', (d) -> d.get 'color')
        .attr('height', 2)
        .attr('width', 136)
        .attr('x', (s) =>
          column = if s.get('target_line_position') == '1' # Brrrrr
            'start_year'
          else
            'end_year'
          @x(App.settings.get column) - 15)
        .attr('y', 0)

    refresh: =>
      # calculate tallest column
      tallest = Math.max(
        _.sum(@model.values_future()),
        _.sum(@model.values_present()),
        _.max(@model.target_results()) || 0
      )
      # update the scales as needed
      @y = @y.domain([0, tallest])
      @inverted_y = @inverted_y.domain([0, tallest])

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      # let the stack method filter the data again, adding the offsets as needed
      stacked_data = _.flatten @stack_method(@prepare_data())
      @svg.selectAll('rect.serie')
        .data(stacked_data, (s) -> s.id)
        .transition()
        .attr('x', (d) => @x(d.x))
        .attr('y', (d) => @height - @y(d.y0 + d.y))
        .attr('height', (d) => @y(d.y))

      # move the target lines
      @svg.selectAll('rect.target_line')
        .data(@model.target_series(), (d) -> d.get 'gquery_key')
        .transition()
        .attr('y', (d) => @height - @y(d.future_value()))

    # the stack layout method expects data to be in a precise format. We could
    # force the values() method but this way is simpler and cleaner.
    prepare_data: =>
      @model.non_target_series().map (s) ->
        [
          {
            x: App.settings.get('start_year')
            y: s.present_value()
            id: "#{s.get 'gquery_key'}_present"
            color: s.get('color')
          },
          {
            x: App.settings.get('end_year')
            y: s.future_value()
            id: "#{s.get 'gquery_key'}_future"
            color: s.get('color')
          }
        ]
