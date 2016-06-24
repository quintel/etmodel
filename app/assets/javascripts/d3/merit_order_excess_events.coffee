D3.merit_order_excess_events =
  View: class extends D3ChartView
    initialize: ->
      # the initializer is wrapped in a try to prevent IE8 errors. The d3.scale()
      # method raises (on IE8) an exception before we have a chance to notify
      # the user that something went wrong.
       @initialize_defaults()

    margins:
      top: 10
      bottom: 40
      left: 70
      right: 10

    can_be_shown_as_table: -> true

    table_view: -> 'merit_order_excess_table'

    draw_axis: =>
      @svg.append("svg:g")
        .attr("class", "x_axis")
        .attr("transform", "translate(0, #{ @height })")
        .call(@x_axis)

      @svg.append("svg:g")
        .attr("class", "y_axis")
        .call(@y_axis)

    draw_labels: =>
      @svg.append("svg:text")
        .text(I18n.t('output_elements.merit_excess_chart.number_of_events'))
        .attr("x", @height / -2)
        .attr("y", -55)
        .attr("text-anchor", "middle")
        .attr("class", "axis_label")
        .attr("transform", "rotate(270)")

      @svg.append("svg:text")
        .text(I18n.t('output_elements.merit_excess_chart.minimum_duration'))
        .attr("x", @width / 2)
        .attr("y", @height + 35)
        .attr("text-anchor", "middle")
        .attr("class", "axis_label")

    draw: =>
      [@width, @height] = @available_size()

      @svg        = @create_svg_container @width, @height, @margins
      @merit_data = MeritOrderExcessData.set(@model.non_target_series())
      @data       = @merit_data.format()

      @x          = d3.scale.ordinal().rangeRoundBands([0, @width], .1)
      @y          = d3.scale.linear().domain([0, 100]).range([0, @height])
      @inverted_y = @y.copy().range([@height, 0])
      @x_axis     = d3.svg.axis().scale(@x).orient("bottom")
      @y_axis     = d3.svg.axis().scale(@inverted_y).ticks(4).orient("left")

      @x.domain(@data.values.map((d) -> d[0]))

      @svg.selectAll(".x_axis").call(@x_axis.scale(@x))

      @message = $("<div>")
        .addClass("notification")
        .text(I18n.t('output_elements.merit_excess_chart.no_excess_message'))

      $(@container_selector()).append(@message)

      @message.css("margin-left",
        (@width / 2) + @margins.left - (@message.width() / 2))

      @toggle_no_excess_message()
      @draw_axis()
      @draw_labels()

      # nodes
      @svg.selectAll('rect.merit_excess_bar')
        .data(@data.values)
        .enter()
        .append("svg:rect")
        .attr("data-rel", (d) -> "duration_of_#{ d[0] }")
        .attr("class", "merit_excess_node")
        .attr("fill", @data.color)
        .attr("x", (d) => @x(d[0]))
        .attr("width", @x.rangeBand())
        .style("stroke", (d) => d3.rgb(@data.color).darker(1))
        .on("mouseover", =>
          d3.select(d3.event.target)
             .attr("fill", d3.rgb(@data.color).brighter(1))
        )
        .on("mouseout", (e) =>
          d3.select(d3.event.target).attr("fill", @data.color)
        )
        .attr('data-tooltip-title', (d) => I18n.t "output_element_series.#{ @data.key }")

      $("#{@container_selector()} rect.merit_excess_node").qtip
        content:
          title: -> $(this).attr('data-tooltip-title')
          text:  -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom right'
          at: 'top center'

      @check_merit_enabled()

    toggle_no_excess_message: =>
      @message.toggle(@merit_data.isEmpty())

    refresh: =>
      @merit_data = MeritOrderExcessData.set(@model.non_target_series())
      @data       = @merit_data.format()
      max_height  = @merit_data.maxY()

      @y.domain([0, max_height * 1.10])
      @inverted_y.domain([0, max_height * 1.10])
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      @toggle_no_excess_message()

      # let's calculate the x-offset of the blocks
      @svg.selectAll('rect.merit_excess_node')
        .data(@data.values)
        .transition()
        .attr("height", (d) => @y(d[1]))
        .attr("y", (d) => @inverted_y(d[1]))
        .attr("data-tooltip-text", (d) =>
          "#{I18n.t('output_elements.merit_excess_chart.minimum_duration')}: #{d[0]}
           <br/>
           #{I18n.t('output_elements.merit_excess_chart.number_of_events')}: #{d[1]}"
        )
