class Node
  constructor: (attrs) ->
    @x = attrs.x
    @y = attrs.y
    @key = attrs.key
    @fill_color = attrs.fill_color
    @stroke_color = attrs.stroke_color
    @sector = attrs.sector
    @use = attrs.use
    @group = attrs.group
    @summary_available = attrs.summary_available

  # returns true if the node hasn't good coordinates
  bad_node: =>
    return true unless @x? && @y?
    return true if @x == 0 && @y == 0
    false

class Link
  constructor: (opts) ->
    @left = opts.left
    @right = opts.right
    @color = opts.color
    @type = opts.type

  path_points: =>
    left_x  = @left.x + 100
    right_x = @right.x
    left_y  = @left.y + 25
    right_y = @right.y + 25
    distance = right_x - left_x

    [
      {x: left_x,  y: left_y},
      {x: left_x + distance / 4,  y: left_y},
      {x: right_x - distance / 4, y: right_y}
      {x: right_x, y: right_y}
    ]

class Topology
  constructor: ->
    @el = $("#topology")
    @width = @el.width()
    @height = @el.height()
    d3.json globals.api_url + '/api/v3/converters/topology', @render

  render: (data) =>
    return if @rendered

    @nodes = []
    @nodes_map = {}
    for d in data.converters
      i = new Node(d)
      continue if i.bad_node()
      @nodes.push i
      @nodes_map[i.key] = i

    @links = []
    for l in data.links
      left = @nodes_map[l.left]
      right = @nodes_map[l.right]
      if left && right
        @links.push new Link({left: left, right: right, color: l.color, type: l.type})

    @svg = d3.select('#topology')
      .append('svg')
      .attr('width', @width)
      .attr('height', @height)
      .attr("pointer-events", "all")
      .call(d3.behavior.zoom().scaleExtent([0.9,15]).on("zoom", @rescale))
      .append('g')

    max_x = d3.max(@nodes, (d) -> d.x) + 50
    max_y = d3.max(@nodes, (d) -> d.y) + 50
    @x = d3.scale.linear().domain([0, max_x]).range([0, @width])
    @y = d3.scale.linear().domain([0, max_y]).range([0, @height])

    @nodes = @svg.selectAll('g.node')
      .data(@nodes, (d) -> d.key)
      .enter()
      .append('g')
      .attr('class', 'node')
      .attr('transform', (d) => "translate(#{@x d.x},#{@y d.y})")
      .attr('data-key', (d) -> d.key)
    @nodes.append('svg:rect')
      .attr('width', @x 100)
      .attr('height', @y 50)
      .attr('fill', (d) -> d.fill_color)
      .attr('stroke', (d) -> d.stroke_color)
    @nodes.append('svg:text')
      .text((d) -> d.key)
      .attr('dy', 1.5)

    @converter_tooltip_template = _.template $("#converter-tooltip-template").html()
    @converter_details_template = _.template $("#converter-details-template").html()

    $('g.node').qtip
        content:
          title: -> $(this).attr('data-key')
          text: (item) =>
            key = $(item.target).closest('g').attr('data-key')
            i = @nodes_map[key]
            @converter_tooltip_template
              key: key
              sector: i.sector
              use: i.use
              group: i.group
              summary_available: i.summary_available
        position:
          my: 'bottom center'
          at: 'top center'
        hide:
          fixed: true
          delay: 400
        style:
          classes: "ui-tooltip-blue"
          width: 360
          tip:
            corner: false
    # show extra converter info
    $(document).on "click", ".converter_tooltip a", (e) =>
      e.preventDefault()
      url = $(e.target).attr('href')
      $.ajax
        url: url
        dataType: 'json'
        success: (data) =>
          html = if _.keys(data.data).length > 0
            @converter_details_template
              data: data.data
              uses_coal_and_wood_pellets: data.uses_coal_and_wood_pellets
              title: ''
          else
            'No extra info available'
          $(e.target).parent().html(html)


    @make_line = d3.svg.line()
        .interpolate("basis")
        .x((d) -> @x d.x)
        .y((d) -> @y d.y)

    @links = @svg.selectAll('path.link')
      .data(@links)
      .enter()
      .append('path')
      .attr('class', 'link')
      .style('stroke', (d) -> d.color)
      .attr('d', (link) => @make_line link.path_points())

    @rendered = true

  rescale: =>
    trans = d3.event.translate
    scale = d3.event.scale
    @svg.attr("transform", "translate(#{trans}) scale(#{scale})")

$ ->
  window.chart = new Topology()