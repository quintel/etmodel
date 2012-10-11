class Node
  constructor: (attrs) ->
    @x = attrs.x
    @y = attrs.y
    @key = attrs.key

class Topology
  constructor: ->
    @width = 800
    @height = 500
    d3.json 'http://etengine.dev/api/v3/converters/topology', @render

  render: (data) =>
    return if @rendered

    @items = []
    @items_map = {}
    for d in data.converters
      i = new Node(d)
      @items.push i
      @items_map[i.key] = i

    @svg = d3.select('#topology')
      .append('svg')
      .attr('width', @width)
      .attr('height', @height)
      .attr("pointer-events", "all")
      .call(d3.behavior.zoom().on("zoom", @rescale))
      .append('g')

    max_x = d3.max(@items, (d) -> d.x) + 50
    max_y = d3.max(@items, (d) -> d.y) + 50
    @x = d3.scale.linear().domain([0, max_x]).range([0, @width])
    @y = d3.scale.linear().domain([0, max_y]).range([0, @height])

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

    @rendered = true

    $('rect').qtip
      content: -> $(this).attr('data-tooltip')
      position:
        my: 'bottom left'
        at: 'top center'
      style:
        classes: "ui-tooltip-tipsy"

  rescale: =>
    console.log "Rescaling"
    trans = d3.event.translate
    scale = d3.event.scale
    @svg.attr("transform", "translate(#{trans}) scale(#{scale})")

$ ->
  window.chart = new Topology()