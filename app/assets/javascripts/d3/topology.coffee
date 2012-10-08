class Topology
  constructor: ->
    console.log 'hi'
    d3.json 'http://etengine.dev/api/v3/converters/topology', @render

  render: (data) =>
    @svg = d3.selectAll('#topology')
      .append('svg:svg')
      .attr('height', 700)
      .attr('width', 1000)

    max_x = d3.max(data, (d) -> d.x) + 50
    max_y = d3.max(data, (d) -> d.y) + 50
    @x = d3.scale.linear().domain([0, max_x]).range([0, 1000])
    @y = d3.scale.linear().domain([0, max_y]).range([0, 700])

    @colors = d3.scale.category20c()

    @nodes = @svg.selectAll('g.node')
      .data(data, (d) -> d.key)
      .enter()
      .append('g')
      .attr('class', 'node')
      .attr('transform', (d) => "translate(#{@x d.x},#{@y d.y})")

    @nodes.append('svg:rect')
      .attr('width', @x 100)
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


$ ->
  new Topology()