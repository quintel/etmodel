# A bar chart / histogram which plots capacity and cost. Both the height and
# width of the bar are adjusted according to the x and y values.
D3.cost_capacity_bar =
  View: class extends D3ChartView
    initialize: ->
      # the initalizer is wrapped in a try to prevent IE8 errors. The d3.scale()
      # method raises (on IE8) an exception before we have a chance to notify
      # the user that something went wrong.
      @initialize_defaults()

    margins:
      top: 10
      bottom: 40
      left: 50
      right: 10

    is_empty: =>
      !_.find(
        @model.non_target_series(), (s) -> s.future_value().capacity,
        _.identity
      )

    # Provides axis and tooltip translations customised for the chart.
    t: (key) =>
      I18n.t(
        "output_elements.#{@model.get('key')}_chart.#{key}",
        defaults: [{ scope: "output_elements.cost_capacity_chart.#{key}" }]
      )

    draw: =>
      [@width, @height] = @available_size()

      @svg        = @create_svg_container @width, @height, @margins
      @merit_data = MeritOrderData.set(@model.non_target_series())
      @data       = @merit_data.format()

      @x          = d3.scale.linear().domain([0, 100]).range([0, @width])
      @y          = d3.scale.linear().domain([0, 100]).range([0, @height])
      @inverted_y = @y.copy().range([@height, 0])
      @x_axis     = d3.svg.axis().scale(@x).ticks(4).orient("bottom")
                      .tickFormat((x) => @main_formatter()(x))
      @y_axis     = d3.svg.axis().scale(@inverted_y).ticks(4).orient("left")

      # axis
      @svg.append("svg:g")
        .attr("class", "x_axis")
        .attr("transform", "translate(0, #{@height})")
        .call(@x_axis)

      @svg.append("svg:g")
        .attr("class", "y_axis")
        .call(@y_axis)

      @svg.append("svg:text")
        .text("#{@t('operating_costs')} (#{@format_cost(1).split(' ')[1]})")
        .attr("x", @height / -2)
        .attr("y", -35)
        .attr("text-anchor", "middle")
        .attr("class", "axis_label")
        .attr("transform", "rotate(270)")

      @svg.append("svg:text")
        .text("#{@t('installed_capacity')}")
        .attr("x", @width / 2)
        .attr("y", @height + 35)
        .attr("text-anchor", "middle")
        .attr("class", "axis_label")

      # nodes
      @svg.selectAll('rect.merit_order_node')
        .data(@data, (d) -> d.key)
        .enter()
        .append("svg:rect")
        .attr("data-rel", (d) -> d.key)
        .attr("class", "merit_order_node")
        .attr("fill", (d) => d.color)
        .style("stroke", (d) => d3.rgb(d.color).darker(0.5))
        .on("mouseover", ->
          d3.select(this).attr("fill", (d) -> d3.rgb(d.color).brighter(0.5))
        )
        .on("mouseout", ->
          d3.select(this).attr("fill", (d) -> d.color)
        )
        .attr('data-tooltip-title', (d) -> d.label)

      $("#{@container_selector()} rect.merit_order_node").qtip
        content:
          title: -> $(this).attr('data-tooltip-title')
          text:  -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom right'
          at: 'top center'

      @check_merit_enabled()
      @draw_merit_legend()

    draw_merit_legend: =>
      @$el.find("div.legend").remove()

      @draw_legend
        columns:     2
        width:       @width
        series:      @merit_data.legendData()
        left_margin: 15

    # Internal: Returns a function which will format values for the "main" axis
    # of the chart.
    main_formatter: (opts = {}) =>
      @create_scaler(@max_series_value(), 'MW', opts)

    # Formats a cost / price value shown on the y-axis.
    format_cost: (value) =>
      Metric.autoscale_value(value, @model.get('unit'), 2)

    max_series_value: ->
      _.max(_.map(@data, (n) -> n.capacity))

    refresh: =>
      # updated scales and axis
      #
      @merit_data = MeritOrderData.set(@model.non_target_series())
      @data       = @merit_data.format()
      max_height  = @merit_data.maxHeight()

      @y.domain([0, max_height])
      @inverted_y.domain([0, max_height])
      @x.domain([0, @merit_data.totalWidth()])

      @svg.selectAll(".x_axis").transition().call(@x_axis.scale(@x))
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      @min_node_height = 2

      @draw_merit_legend()

      # let's calculate the x-offset of the blocks
      offset = 0

      sorted = _.sortBy(@data, (d) -> d.operating_costs).map (d) ->
        value  = offset
        offset += d.capacity

        d.x_offset = value

      @svg.selectAll('rect.merit_order_node')
        .data(@data, (d) -> d.key)
        .transition()
        .attr("height", (d) =>
          if (height = @y(d.operating_costs)) < @min_node_height
            @min_node_height
          else
            height
        )
        .attr("width", (d) => @x(d.capacity))
        .attr("y", (d) =>
          if (height = @y(d.operating_costs)) < @min_node_height
            @height - @min_node_height
          else
            @height - height
        )
        .attr("x", (d) => @x(d.x_offset) + 1)
        .attr("data-tooltip-text", (d) =>
          html =
          """
          #{@t('installed_capacity')}: #{@main_formatter(precision: 2)(d.capacity)}
          <br/>
          #{@t('operating_costs')}: #{@format_cost(d.operating_costs)}
          """

          if d.load_factor
            html += "<br/>#{@t('load_factor')}: #{Metric.ratio_as_percentage(d.load_factor)}"

          if d.type == 'must_run'
            html += '*<br/>* Must run plants do not participate in merit order'

          if d.production == 0
            html += '*<br/>* Assigned 0 costs because production is 0'

          html
        )
