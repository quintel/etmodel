class Topology
  width: 10000
  height: 5000
  render: =>
    console.log "Hi"
    @x = d3.scale.linear().domain([0, 10000]).range([0, @width])
    @y = d3.scale.linear().domain([0, 10000]).range([0, @height])
    @container = d3.select("#container").
      append("svg:svg").
      attr("width", @width).
      attr("height", @height)
    $.ajax
      url: 'http://etengine.dev/api/v3/graph/topology'
      method: 'GET'
      success: @draw_nodes

  draw_nodes: (data) =>
    # let's make an array of converters
    converters = []
    for own key, values of data.converters
      converters.push
        name: values.name
        code: key
        x: values.x
        y: values.y
        color: values.color
        #console.log converters
    # draw!
    @container.
      selectAll("rect").
      data(converters).
      enter().
      append("svg:rect").
      attr("x", (datum) => @x(datum.x)).
      attr("y", (datum) => @y(datum.y)).
      attr("height", 20).
      attr("width", 250).
      attr("fill", (datum) -> datum.color)
    # add labels
    @container.selectAll("text").
      data(converters).
      enter().
      append("svg:text").
      attr("x", (datum) => @x(datum.x)).
      attr("y", (datum) => @y(datum.y)).
      attr("dx", 10).
      attr("dy", "1.2em").
      attr("text-anchor", "left").
      text((datum) -> datum.name).
      style("color", "red")



$ ->
  t = new Topology()
  t.render()
