D3.merit_order =
  data:
    [
      {key: 'central_gas_chp', color: '#d9d9d9'},
      # {key: 'co_firing_coal'},
      {key: 'coal_chp',        color: '#737373'},
      {key: 'coal_conv',       color: '#000000'},
      {key: 'coal_igcc',       color: '#525252'},
      {key: 'coal_igcc_ccs',   color: '#9ebcda'},
      {key: 'coal_pwd',        color: '#252525'},
      {key: 'coal_pwd_ccs',    color: '#8c96c6'},
      {key: 'gas_ccgt',        color: '#f0f0f0'},
      {key: 'gas_ccgt_ccs',    color: '#bfd3e6'},
      {key: 'gas_conv',        color: '#969696'},
      {key: 'gas_turbine',     color: '#bdbdbd'},
      {key: 'must_run',        color: '#a1d99b'},
      {key: 'nuclear_iii',     color: '#fd8d3c'},
      {key: 'oil_plant',       color: '#7f2704'},
      {key: 'solar_pv',        color: '#fed976'},
      {key: 'wind_turbines',   color: '#4292c6'}
    ]

  Node: class extends Backbone.Model
    initialize: ->
      k = @get 'key'
      @gquery_x = new ChartSerie
        gquery_key: "merit_order_#{k}_capacity_in_merit_order_table"
      D3.merit_order.series.push @gquery_x
      @gquery_y = new ChartSerie
        gquery_key: "merit_order_#{k}_operating_costs_in_merit_order_table"
      D3.merit_order.series.push @gquery_y

    value_x: => @gquery_x.future_value() || 0
    value_y: =>
      if @get('key') == 'must_run'
        1
      else
        @original_y_value()

    original_y_value: => @gquery_y.future_value() || 0

    label: => @get('label') || @get('key')

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      # the initalizer is wrapped in a try to prevent IE8 errors. The d3.scale()
      # method raises (on IE8) an exception before we have a chance to notify
      # the user that something went wrong.
      try
        D3.merit_order.series = @model.series
        @nodes = new D3.merit_order.NodeList(D3.merit_order.data)
      @initialize_defaults()

    draw: =>
      margins =
        top: 10
        bottom: 40
        left: 40
        right: 10
      @margin = 50
      @width = 494 - (margins.left + margins.right)
      @height = 310 - (margins.top + margins.bottom)
      @series_height = 280
      @x = d3.scale.linear().domain([0, 100]).range([0, @width])
      @y = d3.scale.linear().domain([0, 100]).range([0, @series_height])
      # inverted scale used by the y-axis
      @yAxisScale = d3.scale.linear().domain([0, 100]).range([@series_height, 0])
      @xAxis = d3.svg.axis().scale(@x).ticks(4).orient("bottom")
      @yAxis = d3.svg.axis().scale(@yAxisScale).ticks(4).orient("left")
      @svg = d3.select("#d3_container_merit_order").
        append("svg:svg").
        attr("height", @height + margins.top + margins.bottom).
        attr("width", @width + margins.left + margins.right).
        append("svg:g").
        attr("transform", "translate(#{margins.left}, #{margins.top})")

      # axis
      @svg.append("svg:g").
        attr("class", "x_axis").
        attr("transform", "translate(0, #{@height})").
        call(@xAxis)
      @svg.append("svg:g").
        attr("class", "y_axis").
        call(@yAxis)
      @svg.append("svg:text").
        text('Operating Costs [EUR/MWh]').
        attr("x", @height / -2).
        attr("y", -25).
        attr("text-anchor", "middle").
        attr("class", "axis_label").
        attr("transform", "rotate(270)")

      @svg.append("svg:text")
        .text('Installed Capacity [MW]')
        .attr("x", @width / 2)
        .attr("y", @series_height + 10)
        .attr("text-anchor", "middle")
        .attr("class", "axis_label")

      # nodes
      @svg.selectAll('rect.merit_order_node').
        data(@nodes.models, (d) -> d.get('key')).
        enter().
        append("svg:rect").
        attr("data-rel", (d) -> d.get('key')).
        attr("class", "merit_order_node").
        attr("fill", (d) => d.get 'color').
        style("stroke", (d) => d3.rgb(d.get 'color').darker(1)).
        on("mouseover", ->
          item = d3.select(this)
          item.transition().attr("fill", (d) -> d3.rgb(d.get("color")).brighter(1))
        ).
        on("mouseout", ->
          item = d3.select(this)
          item.transition().attr("fill", (d) -> d.get("color"))
        )

      $('rect.merit_order_node').qtip
        content: -> $(this).attr('data-tooltip')
        position:
          target: 'mouse'
          my: 'bottom right'
          at: 'top center'

      # add legend
      legends = @svg.selectAll("svg.legend").
        data(@nodes.models, (d) -> d.get('key')).
        enter().
        append("svg:svg").
        attr("class", "legend").
        attr("x", (d, i) -> 115 * (Math.floor(i / 4)) + 10).
        attr("y", (d, i) -> 18 * (i % 4)).
        attr("height", 30).
        attr("width", 110)

      legends.append("svg:rect").
        attr("width", 10).
        attr("height", 10).
        attr("fill", (d) => d.get 'color')
      legends.append("svg:text").
        text((d) -> I18n.t "output_element_series.#{d.get('key')}").
        attr("x", 15).
        attr("y", 8).
        attr("class", (d) -> d.get 'key')

    refresh: =>
      @y          = d3.scale.linear().domain([0, @nodes.max_height()]).range([0, @height])
      @yAxisScale = d3.scale.linear().domain([0, @nodes.max_height()]).range([@height, 0])
      @x = d3.scale.linear().domain([0, @nodes.total_width()]).range([0, @width])
      @svg.selectAll(".x_axis").transition().call(@xAxis.scale(@x))
      @svg.selectAll(".y_axis").transition().call(@yAxis.scale(@yAxisScale))

      @min_node_height = 2

      # let's calculate the x-offset
      offset = 0
      sorted = @nodes.sortBy((d) -> d.value_y()).map (d) ->
        value = offset
        offset += d.value_x()
        d.set {x_offset: value}

      @svg.selectAll('rect.merit_order_node').
        data(@nodes.models, (d) -> d.get('key')).
        transition().duration(500).
        attr("height", (d) =>
          if (h = @y(d.value_y())) < @min_node_height
            @min_node_height
          else
            h
        ).
        attr("width", (d) => @x(d.value_x())).
        attr("y", (d) =>
          if (h = @y(d.value_y())) < @min_node_height
            @height - @min_node_height
          else
            @height - h
        ).
        attr("x", (d) => @x(d.get 'x_offset')).
        attr("data-tooltip", (d) ->
          html = I18n.t "output_element_series.#{d.get('key')}"
          html += "<br/>"
          html += "Installed capacity: #{Metric.autoscale_value(d.value_x() * 1000000, 'MW', 2)}"
          html += "<br/>"
          html += "Operating costs: #{Metric.autoscale_value d.original_y_value(), 'euro', 2}"
          if d.get('key') == 'must_run'
            html += '*<br/>* Must run plants do not participate in merit order'
          html
        )


class D3.merit_order.NodeList extends Backbone.Collection
  model: D3.merit_order.Node

  max_height: =>
    _.max(@map (i) -> i.value_y())

  total_width: =>
    tot = 0
    @each (i) -> tot += i.value_x()
    tot
