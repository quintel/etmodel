class Node
  constructor: (attrs) ->
    @x = attrs.x
    @y = attrs.y
    @key = attrs.key

class Topology
  constructor: ->
    d3.json 'http://etengine.dev/api/v3/converters/topology', @render

  render: (data) =>
    @items = []
    @items_map = {}
    for d in data
      i = new Node(d)
      @items.push i
      @items_map[i.key] = i

    @svg = d3.selectAll('#topology')
      .append('svg:svg')
      .attr('height', 700)
      .attr('width', 1000)

    max_x = d3.max(@items, (d) -> d.x) + 50
    max_y = d3.max(@items, (d) -> d.y) + 50
    @x = d3.scale.linear().domain([0, max_x]).range([0, 1000])
    @y = d3.scale.linear().domain([0, max_y]).range([0, 700])

    @colors = d3.scale.category20c()

    @nodes = @svg.selectAll('g.node')
      .data(@items, (d) -> d.key)
      .enter()
      .append('g')
      .attr('class', 'node')
      .attr('transform', (d) => "translate(#{@x d.x},#{@y d.y})")

    @nodes.append('svg:rect')
      .attr('width', @x 70)
      .attr('height', @y 50)
      .attr('fill', (d, i) => @colors i)
      .attr('data-tooltip', (d) -> d.key)

    $('rect').qtip
      content: -> $(this).attr('data-tooltip')
      position:
        my: 'bottom left'
        at: 'top center'
      style:
        classes: "ui-tooltip-tipsy"

  zoom_in: => @zoom(0.5)

  zoom_out: => @zoom(2)

  zoom: (x) =>
    old = @x.domain()
    @x.domain([old[0], old[1] * x])
    old = @y.domain()
    @y.domain([old[0], old[1] * x])
    @redraw()


  redraw: =>
    @svg.selectAll('g.node').transition()
      .attr('transform', (d) => "translate(#{@x d.x},#{@y d.y})")

    @svg.selectAll('rect')
      .transition()
      .attr('width', @x 70)
      .attr('height', @y 50)


$ ->
  window.chart = new Topology()