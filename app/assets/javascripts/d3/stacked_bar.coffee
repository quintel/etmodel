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
        .data(@model.non_target_series())
        .enter()
        .append("svg:g")
        .attr("class", "legend")
        .attr("transform", (d, i) -> "translate(#{100 * (i % 4) + 10}, #{Math.floor(i / 4) * 30})")
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

      @stack_method = d3.layout.stack().offset('zero')
      stacked_data = _.flatten @stack_method(@prepare_data())

      @x = d3.scale.ordinal().rangeRoundBands([0, @width])
        .domain([App.settings.get('start_year'), App.settings.get('end_year')])
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

      @y_axis = d3.svg.axis().scale(@inverted_y).ticks(4).orient("right")
      @svg.append("svg:g")
        .attr("class", "y_axis")
        .attr("transform", "translate(#{@width - 25}, 0)")
        .call(@y_axis)

    refresh: =>
      # calculate tallest column
      tallest = Math.max(
        _.sum(@model.values_future()),
        _.sum(@model.values_present())
      )
      @y = @y.domain([0, tallest])
      @inverted_y = @inverted_y.domain([0, tallest])
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))


      stacked_data = _.flatten @stack_method(@prepare_data())
      @svg.selectAll('rect.serie')
        .data(stacked_data, (s) -> s.id)
        .transition()
        .attr('x', (d) => @x(d.x))
        .attr('y', (d) => @height - @y(d.y0 + d.y))
        .attr('height', (d) => @y(d.y))

    # the stack layout method expects data to be in a precise format
    prepare_data: =>
      @model.non_target_series().map (s) ->
        [
          {x: App.settings.get('start_year'), y: s.present_value(), id: "#{s.get 'gquery_key'}_present", color: s.get('color')},
          {x: App.settings.get('end_year'),  y: s.future_value(),  id: "#{s.get 'gquery_key'}_future", color: s.get('color')}
        ]
