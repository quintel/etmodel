data =
  nodes: [
    {id: 'industry', value: 20, column: 0, row: 0},
    {id: 'other', value: 20, column: 0, row: 1},
    {id: 'households', value: 20, column: 0, row: 2},
    {id: 'agriculture', value: 20, column: 0, row: 3},
    {id: 'buildings', value: 20, column: 0, row: 4},
    {id: 'transport', value: 20, column: 0, row: 5},
    {id: 'el_production', value: 100, column: 1, row: 1},
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


class Node extends Backbone.Model
  @width: 100
  @horizontal_spacing: 400
  y_offset: => @get('row') * 100
  x_offset: => @get('column') * Node.horizontal_spacing + 20
  x_center: => @x_offset() + Node.width / 2
  y_center: => @y_offset() + @get("value") / 2

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

  # this is the link function we'll be using
  link_line: d3.svg.line().
    interpolate("basis").
    x((d) -> d.x).
    y((d) -> d.y)

  # returns the path points in the svg format
  svg_path: =>
    @link_line @path_points()

class LinkList extends Backbone.Collection
  model: Link

  # returns the end points for the links
  path_points: =>
    @map (link) -> link.path_points()

class Sankey extends Backbone.View
  el: "body"

  events:
    "click a#random": "randomize"

  randomize: (e) =>
    e.preventDefault()
    updates = []
    nodes.each (node) ->
      node.set
        value: 100 * Math.random()
    links.each (link) ->
      min = _.min [link.left.get('value'), link.right.get('value')]
      link.set
        value: min * Math.random()
    @refresh()

  render: =>
    @svg = d3.select("#container").
      append("svg:svg").
      attr("height", "700").
      attr("width", "1000")

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
      attr("d", (link) -> link.svg_path())

    @nodes = @svg.selectAll("rect").
      data(nodes.models, (d) -> d.get('id')).
      enter().
      append("rect").
      attr("x", (datum) -> Node.horizontal_spacing * datum.get('column') + 20).
      attr("y", (datum) -> 100 * datum.get ('row')).
      attr("width", Node.width).
      attr("height", (datum) -> datum.get('value')).
      attr("stroke", "gray").
      attr("fill", (datum, i) -> colors(i))

    @labels = @svg.selectAll("text.label").
      data(nodes.models, (d) -> d.get('id')).
      enter().
      append("svg:text").
      attr("class", "label").
      attr("x", (datum) -> datum.x_offset()).
      attr("y", (datum) -> datum.y_center() + 5).
      attr("dx", 10).
      text((datum) -> datum.get('id')).
      style("color", "black")

  link_line: d3.svg.line().
    interpolate("basis").
    x((d) -> d.x).
    y((d) -> d.y)

  refresh: =>
    @nodes.data(nodes.models, (d) -> d.get('id')).
      transition().duration(500).
      attr("height", (datum) -> datum.get('value'))

    @labels.data(nodes.models, (d) -> d.get('id')).
      transition().duration(500).
      attr("y", (datum) -> datum.y_center() + 5)

    @links.data(links.models, (d) -> d.cid).
      transition().duration(500).
      attr("d", (link) -> link.svg_path()).
      style("stroke-width", (link) -> link.get('value'))

$ ->
  window.nodes = new NodeList(data.nodes)
  window.links = new LinkList(data.links)
  window.chart = new Sankey()
  chart.render()
