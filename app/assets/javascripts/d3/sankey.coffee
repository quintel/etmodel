D3.sankey =
  data :
    nodes: [
      {id: 'industry', value: 20, column: 0, row: 0, gquery: 'final_demand_from_industry_and_energy_sector'},
      {id: 'other', value: 20, column: 0, row: 1, gquery: 'final_demand_from_other_sector'},
      {id: 'households', value: 20, column: 0, row: 2, gquery: 'final_demand_from_households'},
      {id: 'agriculture', value: 20, column: 0, row: 3, gquery: 'final_demand_from_agriculture'},
      {id: 'buildings', value: 20, column: 0, row: 4, gquery: 'final_demand_from_buildings'},
      {id: 'transport', value: 20, column: 0, row: 5, gquery: 'final_demand_from_transport'},
      {id: 'el_production', value: 20, column: 1, row: 1, gquery: 'total_electricity_produced'},
      {id: 'coal', value: 30, column: 2, row: 0},
      {id: 'nuclear', value: 30, column: 2, row: 1},
      {id: 'gas', value: 30, column: 2, row: 2},
      {id: 'oil', value: 30, column: 2, row: 3},
      {id: 'renewables', value: 30, column: 2, row: 4}
    ]
    links: [
      {left: 'industry', right: 'coal', value: 10},
      {left: 'industry', right: 'el_production', value: 10},
      {left: 'other', right: 'el_production', value: 10},
      {left: 'households', right: 'el_production', value: 10},
      {left: 'agriculture', right: 'el_production', value: 10},
      {left: 'buildings', right: 'el_production', value: 10},
      {left: 'transport', right: 'el_production', value: 10},
      {left: 'el_production', right: 'coal', value: 5, gquery: 'electricity_produced_from_coal'},
      {left: 'el_production', right: 'nuclear', value: 5, gquery: 'electricity_produced_from_uranium'},
      {left: 'el_production', right: 'gas', value: 5, gquery: 'electricity_produced_from_natural_gas'},
      {left: 'el_production', right: 'oil', value: 5, gquery: 'electricity_produced_from_oil'},
      {left: 'el_production', right: 'renewables', value: 5, gquery: 'electricity_produced_from_solar'}
      {left: 'transport', right: 'oil', value: 5, gquery: 'primary_demand_of_crude_oil_from_transport'}
      {left: 'agriculture', right: 'oil', value: 5, gquery: 'primary_demand_of_crude_oil_from_agriculture'}
      {left: 'households', right: 'gas', value: 5}
      {left: 'buildings', right: 'gas', value: 5}
    ]

  # Helper classes
  #
  Node: class extends Backbone.Model
    @width: 100
    @horizontal_spacing: 400
    y_offset: => @get('row') * 100
    x_offset: => @get('column') * D3.sankey.Node.horizontal_spacing + 20
    x_center: => @x_offset() + D3.sankey.Node.width / 2
    y_center: => @y_offset() + @get("value") / 2

    value: =>
      if @gquery
        @gquery.get('future_value') / 20000000000
      else
        @get 'value'

    initialize: =>
      if @get('gquery')
        @gquery = new Gquery({key: @get('gquery')})
      @right_links = []
      @left_links = []

    height: => @value()

  Link: class extends Backbone.Model
    initialize: =>
      @module = D3.sankey
      @left = @module.nodes.get @get('left')
      @right = @module.nodes.get @get('right')
      if @get('gquery')
        @gquery = new Gquery({key: @get('gquery')})
      @left.right_links.push this
      @right.left_links.push this

    left_y:  =>
      offset = 0
      for link in @left.right_links
        break if link == this
        offset += link.height()
      @left.y_center() + offset
    right_y:  =>
      offset = 0
      for link in @right.left_links
        break if link == this
        offset += link.height()
      @right.y_center() + offset
    left_x:  => @left.x_center() + @module.Node.width / 2
    right_x: => @right.x_center() - @module.Node.width / 2

    path_points: =>
      [
          x: @left_x()
          y: @left_y()
        ,
          x: @left_x() + 80
          y: @left_y()
        ,
          x: @right_x() - 80
          y: @right_y()
        ,
          x: @right_x()
          y: @right_y()
      ]

    value: =>
      if @gquery
        @gquery.get('future_value') / 20000000000
      else
        @get 'value'

    height: => @value()

  # This is the main chart class
  #
  View: class extends D3ChartView
    el: "body"

    randomize: =>
      @module.nodes.each (node) ->
        node.set
          value: 100 * Math.random()
      @module.links.each (link) ->
        min = _.min [link.left.get('value'), link.right.get('value')]
        link.set
          value: min * Math.random()
      @refresh()

    draw: =>
      @svg = d3.select("#d3_container").
        append("svg:svg").
        attr("height", @height).
        attr("width", @width)

      colors = d3.scale.category20()

      @links = @svg.selectAll('path.link').
        data(@module.links.models, (d) -> d.cid).
        enter().
        append("svg:path").
        attr("class", "link").
        style("stroke-width", (link) -> link.value()).
        style("stroke", "steelblue").
        style("fill", "none").
        style("opacity", 0.8).
        on('mouseover', ->
          d3.select(this).transition().duration(900).style("stroke", "red")
        ).
        on('mouseout', ->
          d3.select(this).transition().duration(200).style("stroke", "steelblue")
        ).
        attr("d", (link) => @link_line link.path_points())

      @nodes = @svg.selectAll("rect").
        data(@module.nodes.models, (d) -> d.get('id')).
        enter().
        append("rect").
        attr("x", (d) => @x(@module.Node.horizontal_spacing * d.get('column') + 20)).
        attr("y", (d) => @y(100 * d.get ('row'))).
        attr("width", @x @module.Node.width).
        attr("height", (d) => @y d.value()).
        attr("stroke", "gray").
        attr("fill", (datum, i) -> colors(i))

      @labels = @svg.selectAll("text.label").
        data(@module.nodes.models, (d) -> d.get('id')).
        enter().
        append("svg:text").
        attr("class", "label").
        attr("x", (d) => @x d.x_offset()).
        attr("y", (d) => @y(d.y_center() + 5)).
        attr("dx", 10).
        text((d) -> d.get('id')).
        style("color", "black")

    refresh: =>
      @nodes.data(@module.nodes.models, (d) -> d.get('id')).
        transition().duration(500).
        attr("height", (d) => @y d.value())

      @labels.data(@module.nodes.models, (d) -> d.get('id')).
        transition().duration(500).
        attr("y", (datum) => @y(datum.y_center() + 5))

      @links.data(@module.links.models, (d) -> d.cid).
        transition().duration(500).
        attr("d", (link) => @link_line link.path_points()).
        style("stroke-width", (link) => @y(link.value()))

    initialize: ->
      @module = D3.sankey
      @module.nodes = new @module.NodeList(@module.data.nodes)
      @module.links = new @module.LinkList(@module.data.links)
      @initialize_defaults()
      @x = d3.scale.linear().
        domain([0, 1000]).
        range([0, @width])

      @y = d3.scale.linear().
        domain([0, 700]).
        range([0, @height])

      @link_line = d3.svg.line().
        interpolate("basis").
        x((d) -> @x(d.x)).
        y((d) -> @y(d.y))

class D3.sankey.NodeList extends Backbone.Collection
  model: D3.sankey.Node

class D3.sankey.LinkList extends Backbone.Collection
  model: D3.sankey.Link

