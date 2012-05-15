data =
  nodes: [
    {id: 'industry', value: 20, column: 0, row: 0, gquery: 'final_demand_from_industry_and_energy_sector'},
    {id: 'other', value: 20, column: 0, row: 1, gquery: 'final_demand_from_other_sector'},
    {id: 'households', value: 20, column: 0, row: 2, gquery: 'final_demand_from_households'},
    {id: 'agriculture', value: 20, column: 0, row: 3, gquery: 'final_demand_from_agriculture'},
    {id: 'buildings', value: 20, column: 0, row: 4, gquery: 'final_demand_from_buildings'},
    {id: 'transport', value: 20, column: 0, row: 5, gquery: 'final_demand_from_transport'},
    {id: 'el_production', value: 20, column: 1, row: 1, gquery: 'total_electricity_production'},
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
    {left: 'el_production', right: 'coal', value: 5},
    {left: 'el_production', right: 'nuclear', value: 5},
    {left: 'el_production', right: 'gas', value: 5},
    {left: 'el_production', right: 'oil', value: 5},
    {left: 'el_production', right: 'renewables', value: 5}
    {left: 'transport', right: 'oil', value: 5}
    {left: 'agriculture', right: 'oil', value: 5}
    {left: 'households', right: 'gas', value: 5}
    {left: 'buildings', right: 'gas', value: 5}
  ]

# Helper classes
#
class Node extends Backbone.Model
  @width: 100
  @horizontal_spacing: 400
  y_offset: => @get('row') * 100
  x_offset: => @get('column') * Node.horizontal_spacing + 20
  x_center: => @x_offset() + Node.width / 2
  y_center: => @y_offset() + @get("value") / 2

  value: =>
    if @gquery
      @gquery.get('future_value') / 20000000000
    else
      @get 'value'

  initialize: =>
    if @get('gquery')
      @gquery = new Gquery({key: @get('gquery')})


class NodeList extends Backbone.Collection
  model: Node

class Link extends Backbone.Model
  initialize: =>
    @left = nodes.get @get('left')
    @right = nodes.get @get('right')

  path_points: =>
    [
        x: @left.x_center() + Node.width / 2
        y: @left.y_center()
      ,
        x: @left.x_center() + Node.width / 2 + 80
        y: @left.y_center()
      ,
        x: @right.x_center() - 80 - Node.width / 2
        y: @right.y_center()
      ,
        x: @right.x_center() - Node.width / 2
        y: @right.y_center()
    ]

class LinkList extends Backbone.Collection
  model: Link

  # returns the end points for the links
  path_points: =>
    @map (link) -> link.path_points()

# This is the main chart class
#
class D3.sankey extends D3ChartView
  el: "body"

  randomize: =>
    nodes.each (node) ->
      node.set
        value: 100 * Math.random()
    links.each (link) ->
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
      data(links.models, (d) -> d.cid).
      enter().
      append("svg:path").
      attr("class", "link").
      style("stroke-width", (link) -> link.get('value')).
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
      data(nodes.models, (d) -> d.get('id')).
      enter().
      append("rect").
      attr("x", (d) => @x(Node.horizontal_spacing * d.get('column') + 20)).
      attr("y", (d) => @y(100 * d.get ('row'))).
      attr("width", @x Node.width).
      attr("height", (d) => @y d.value()).
      attr("stroke", "gray").
      attr("fill", (datum, i) -> colors(i))

    @labels = @svg.selectAll("text.label").
      data(nodes.models, (d) -> d.get('id')).
      enter().
      append("svg:text").
      attr("class", "label").
      attr("x", (d) => @x d.x_offset()).
      attr("y", (d) => @y(d.y_center() + 5)).
      attr("dx", 10).
      text((d) -> d.get('id')).
      style("color", "black")

  refresh: =>
    console.log "Refreshing"
    @nodes.data(nodes.models, (d) -> d.get('id')).
      transition().duration(500).
      attr("height", (d) => @y d.value())

    @labels.data(nodes.models, (d) -> d.get('id')).
      transition().duration(500).
      attr("y", (datum) => @y(datum.y_center() + 5))

    @links.data(links.models, (d) -> d.cid).
      transition().duration(500).
      attr("d", (link) => @link_line link.path_points()).
      style("stroke-width", (link) => @y(link.get('value')))

  initialize: ->
    # TODO: remove from global namespace
    window.nodes = new NodeList(data.nodes)
    window.links = new LinkList(data.links)
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

