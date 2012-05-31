D3.merit_order =
  data:
    [
      {key: 'central_gas_chp'},
      {key: 'co_firing_coal'},
      {key: 'coal_chp'},
      {key: 'coal_conv'},
      {key: 'coal_igcc'},
      {key: 'coal_igcc_ccs'},
      {key: 'coal_pwd'},
      {key: 'coal_pwd_ccs'},
      {key: 'gas_ccgt'},
      {key: 'gas_ccgt_ccs'},
      {key: 'gas_conv'},
      {key: 'gas_turbine'},
      {key: 'must_run'}
      {key: 'nuclear_iii'},
      {key: 'oil_plant'},
      {key: 'solar_pv'},
      {key: 'wind_turbines'},
    ]

  Node: class extends Backbone.Model
    initialize: ->
      k = @get 'key'
      @gquery_x = new Gquery
        key: "merit_order_#{k}_capacity_in_merit_order_table"
      @gquery_y = new Gquery
        key: "merit_order_#{k}_operating_costs_in_merit_order_table"

    value_x: => @gquery_x.get('future_value')
    value_y: => @gquery_y.get('future_value')

    label: => @get('label') || @get('key')

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @color = d3.scale.category20c()
      @nodes = new D3.merit_order.NodeList(D3.merit_order.data)
      @initialize_defaults()

    draw: =>
      @margin = 50
      @width = (@container_node().width()   || 490) - 2 * @margin
      @height = (@container_node().height() || 402) - 2 * @margin
      @x = d3.scale.linear().domain([0, 100]).range([0, @width])
      @y = d3.scale.linear().domain([0, 100]).range([0, @height])
      # inverted scale used by the y-axis
      @yAxisScale = d3.scale.linear().domain([0, 100]).range([@height, 0])
      @xAxis = d3.svg.axis().scale(@x).ticks(4).orient("bottom")
      @yAxis = d3.svg.axis().scale(@yAxisScale).ticks(4).orient("left")
      @svg = d3.select("#d3_container").
        append("svg:svg").
        attr("height", @height + 2 * @margin).
        attr("width", @width + 2 * @margin).
        append("svg:g").
        attr("transform", "translate(#{@margin}, #{@margin})")
      @svg.append("svg:g").
        attr("class", "x axis").
        attr("transform", "translate(0, #{@height})").
        call(@xAxis)
      @svg.append("svg:g").
        attr("class", "y axis").
        call(@yAxis)

      @svg.selectAll('rect.merit_order_node').
        data(@nodes.models, (d) -> d.get('key')).
        enter().
        append("svg:rect").
        attr("data-rel", (d) -> d.get('key')).
        attr("class", "merit_order_node").
        attr("fill", (d, i) => @color(i)).
        attr("stroke", (d, i) => d3.rgb(@color(i)).darker(2)).
        attr("y", (d) => @height - @y(d.value_y()) - .5).
        attr("x", (d, i) -> i * 30).
        attr("height", (d) => @y d.value_y()).
        attr("width", (d) => @x d.value_x())

    refresh: =>
      @y          = d3.scale.linear().domain([0, @nodes.max_height()]).range([0, @height])
      @yAxisScale = d3.scale.linear().domain([0, @nodes.max_height()]).range([@height, 0])
      @x = d3.scale.linear().domain([0, @nodes.total_width()]).range([0, @width])
      @svg.selectAll(".x").transition().call(@xAxis.scale(@x))
      @svg.selectAll(".y").transition().call(@yAxis.scale(@yAxisScale))

      # let's calculate the x-offset
      offset = 0
      sorted = @nodes.sortBy((d) -> d.value_y()).map (d) ->
        value = offset
        offset += d.value_x()
        d.set {x_offset: value}

      @svg.selectAll('rect.merit_order_node').
        data(@nodes.models, (d) -> d.get('key')).
        transition().duration(500).
        attr("height", (d) => @y(d.value_y())).
        attr("width", (d) => @x(d.value_x())).
        attr("y", (d) => @height - @y(d.value_y())).
        attr("x", (d) => @x(d.get 'x_offset'))

class D3.merit_order.NodeList extends Backbone.Collection
  model: D3.merit_order.Node

  max_height: =>
    _.max(@map (i) -> i.value_y())

  total_width: =>
    tot = 0
    @each (i) -> tot += i.value_x()
    tot
