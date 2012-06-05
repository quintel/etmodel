D3.sankey =
  data :
    nodes: [
      {id: 'coal',        column: 0},
      {id: 'nuclear',     column: 0},
      {id: 'gas',         column: 0},
      {id: 'oil',         column: 0},
      {id: 'biomass',     column: 0},
      {id: 'wind',        column: 0},
      {id: 'hydro',       column: 0},
      {id: 'solar',       column: 0},
      {id: 'waste',       column: 0}

      {id: 'el_prod',     column: 1, label: "electricity production"},
      {id: 'heat_prod',   column: 1, label: "heating production"},

      {id: 'households',  column: 2},
      {id: 'buildings',   column: 2},
      {id: 'transport',   column: 2},
      {id: 'industry',    column: 2},
      {id: 'agriculture', column: 2},
      {id: 'other',       column: 2},
      {id: 'loss',        column: 2},

    ]
    links: [
      #Direct links between carrier and sector
	    {left: 'coal',      right: 'households', gquery: 'coal_households_in_mekko_of_final_demand', color: 'black'},
      {left: 'gas',       right: 'households', gquery: 'gas_households_in_mekko_of_final_demand'},
      {left: 'oil',       right: 'households', gquery: 'oil_households_in_mekko_of_final_demand', color: 'brown'},
      {left: 'biomass',   right: 'households',  gquery: 'biomass_households_in_mekko_of_final_demand', color: 'green'},
      {left: 'waste',     right: 'households', gquery: 'waste_households_in_mekko_of_final_demand', color: 'dark_green'}
      # Electricity to sectors
      {left: 'el_prod',   right: 'households',  gquery: 'electricity_households_in_mekko_of_final_demand'},
      {left: 'el_prod',   right: 'buildings',   gquery: 'electricity_buildings_in_mekko_of_final_demand'},
      {left: 'el_prod',   right: 'transport',   gquery: 'electricity_transport_in_mekko_of_final_demand'},
      {left: 'el_prod',   right: 'industry',    gquery: 'electricity_industry_in_mekko_of_final_demand'},
      {left: 'el_prod',   right: 'agriculture', gquery: 'electricity_agriculture_in_mekko_of_final_demand'},
      {left: 'el_prod',   right: 'other',       gquery: 'electricity_other_in_mekko_of_final_demand'},

      {left: 'heat_prod', right: 'households',  gquery: 'hot_water_households_in_mekko_of_final_demand', color: 'red'},
      {left: 'heat_prod', right: 'buildings',   gquery: 'hot_water_buildings_in_mekko_of_final_demand', color: 'red'},
      {left: 'heat_prod', right: 'transport',   gquery: 'hot_water_transport_in_mekko_of_final_demand', color: 'red'},
      {left: 'heat_prod', right: 'industry',    gquery: 'hot_water_industry_in_mekko_of_final_demand', color: 'red'},
      {left: 'heat_prod', right: 'agriculture', gquery: 'hot_water_agriculture_in_mekko_of_final_demand', color: 'red'},
      {left: 'heat_prod', right: 'other',       gquery: 'hot_water_other_in_mekko_of_final_demand', color: 'red'},

      {left: 'coal',      right: 'el_prod',     gquery: 'coal_in_source_of_electricity_production', color: 'black'},
      {left: 'nuclear',   right: 'el_prod',     gquery: 'nuclear_in_source_of_electricity_production', color: 'red'},
      {left: 'gas',       right: 'el_prod',     gquery: 'gas_in_source_of_electricity_production'},
      {left: 'oil',       right: 'el_prod',     gquery: 'oil_in_source_of_electricity_production', color: 'brown'},
      {left: 'biomass',   right: 'el_prod',     gquery: 'biomass_in_source_of_electricity_production', color: 'green'},
      {left: 'wind',      right: 'el_prod',     gquery: 'wind_in_source_of_electricity_production'},
      {left: 'hydro',     right: 'el_prod',     gquery: 'hydro_in_source_of_electricity_production'},
      {left: 'solar',     right: 'el_prod',     gquery: 'solar_in_source_of_electricity_production'},
      {left: 'waste',     right: 'el_prod',     gquery: 'waste_in_source_of_electricity_production'},
      {left: 'coal',      right: 'heat_prod',   gquery: 'coal_in_source_of_electricity_production', color: 'black'},
      {left: 'nuclear',   right: 'heat_prod',   gquery: 'nuclear_in_source_of_electricity_production', color: 'red'},
      {left: 'gas',       right: 'heat_prod',   gquery: 'gas_in_source_of_electricity_production'},
      {left: 'oil',       right: 'heat_prod',   gquery: 'oil_in_source_of_electricity_production', color: 'brown'},
      {left: 'biomass',   right: 'heat_prod',   gquery: 'biomass_in_source_of_electricity_production', color: 'green'},
      {left: 'wind',      right: 'heat_prod',   gquery: 'wind_in_source_of_electricity_production'},
      {left: 'hydro',     right: 'heat_prod',   gquery: 'hydro_in_source_of_electricity_production'},
      {left: 'solar',     right: 'heat_prod',   gquery: 'solar_in_source_of_electricity_production'},
      {left: 'waste',     right: 'heat_prod',   gquery: 'waste_in_source_of_electricity_production'}


    ]

  # Helper classes
  #
  Node: class extends Backbone.Model
    @width: 25
    @horizontal_spacing: 250

    initialize: =>
      # shortcut to access the collection objects
      @module = D3.sankey
      @right_links = []
      @left_links = []

    # vertical position of the node. Adds some margin between nodes
    #
    y_offset: =>
      offset = 0
      margin = 50
      for n in @siblings()
        break if n == this
        offset += n.value() + margin
      offset

    x_offset: => @get('column') * D3.sankey.Node.horizontal_spacing
    x_center: => @x_offset() + D3.sankey.Node.width / 2
    y_center: => @y_offset() + @value() / 2

    # The height of the node is the sum of the height of its link. Since links
    # are both inbound and outbound, let's use the max size. Ideally the values
    # should match
    #
    value: =>
      _.max([
        _.inject(@left_links, ((memo, i) -> memo + i.value()), 0),
        _.inject(@right_links,((memo, i) -> memo + i.value()), 0)
      ])

    # returns an array of the other nodes that belong to the same column. This
    # is used by the +y_offset+ method to calculate the right node position
    #
    siblings: =>
      items = _.groupBy(@module.nodes.models, (node) -> node.get('column'))
      items[@get 'column']

    label: => @get('label') || @get('id')

  Link: class extends Backbone.Model
    initialize: =>
      @module = D3.sankey
      @left = @module.nodes.get @get('left')
      @right = @module.nodes.get @get('right')
      if @get('gquery')
        @gquery = gqueries.find_or_create_by_key @get('gquery')
      # let the nodes know about me
      @left.right_links.push this
      @right.left_links.push this

    # returns the absolute y coordinate of the left anchor point
    #
    # This method should definitely be simplified
    left_y:  =>
      offset = null
      for link in @left.right_links
        # push down the first link
        if offset == null
          offset = link.value() / 2
          break if link == this
          offset = link.value()
        else
          if link == this
            offset += link.value() / 2
            break
          else
            offset += link.value()
      @left.y_offset() + offset

    # see above
    #
    right_y:  =>
      offset = null
      for link in @right.left_links
        # push down the first link
        if offset == null
          offset = link.value() / 2
          break if link == this
          offset = link.value()
        else
          if link == this
            offset += link.value() / 2
            break
          else
            offset += link.value()
      @right.y_offset() + offset

    left_x:  => @left.x_center() + @module.Node.width / 2
    right_x: => @right.x_center() - @module.Node.width / 2

    # Use 4 points and let D3 interpolate a smooth curve
    #
    path_points: =>
      [
        {x: @left_x(),       y: @left_y()},
        {x: @left_x()  + 80, y: @left_y()},
        {x: @right_x() - 80, y: @right_y()},
        {x: @right_x(),      y: @right_y()}
      ]

    value: =>
      if @gquery
        x = @gquery.get('future_value')
      if _.isNumber(x) then x else 0

    color: => @get('color') || "steelblue"

    connects: (id) => @get('left') == id || @get('right') == id

  # This is the main chart class
  #
  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @module = D3.sankey # shortcut
      @module.nodes = new @module.NodeList(@module.data.nodes)
      @module.links = new @module.LinkList(@module.data.links)
      @initialize_defaults()

      @unit_blocks = [
        {id: 1, value: 1},
        {id: 10, value: 10},
        {id: 100, value: 100}
      ]

    # this method is called when we first render the chart. It is called if we
    # want a full chart refresh when the user resizes the browser window, too
    #
    draw: =>
      @margin = 50
      @width = (@container_node().width()   || 490) - 2 * @margin
      @height = (@container_node().height() || 402) - 2 * @margin

      # set up the scaling methods
      @x = d3.scale.linear().domain([0, 600]).range([0, @width])

      # this one will be changed dynamically later on
      @y = d3.scale.linear().domain([0, 5000]).range([0, @height])

      # This is the function that will take care of drawing the links once we've
      # set the base points
      @link_line = d3.svg.line().
        interpolate("basis").
        x((d) -> @x(d.x)).
        y((d) -> @y(d.y))

      @svg = d3.select("#d3_container_sankey").
        append("svg:svg").
        attr("height", @height + 2 * @margin).
        attr("width", @width + 2 * @margin).
        append("svg:g").
        attr("transform", "translate(#{@margin}, #{@margin})")
      @links = @draw_links()
      @nodes = @draw_nodes()
      @axis = @draw_axis()

    draw_axis: =>
      @y_axis = d3.svg.axis().scale(@y).ticks(4).orient("left")
      @svg.append("svg:g").
        attr("class", "y axis").
        attr("transform", "translate(-10, 0)").
        call(@y_axis)

    draw_links: =>
      # links are treated as a group made of a link path and label text element
      #
      links = @svg.selectAll('g.link').
        data(@module.links.models, (d) -> d.cid).
        enter().
        append("svg:g").
        attr("class", (link) ->
          "link #{link.left.get('id')} #{link.right.get('id')}"
        ).
        attr("data-cid", (d) -> d.cid) # unique identifier
      # link path
      #
      links.append("svg:path").
        style("stroke-width", (link) -> link.value()).
        style("stroke", (link, i) -> link.color()).
        style("fill", "none").
        style("opacity", 0.8).
        attr("d", (link) => @link_line link.path_points()).
        on("mouseover", @link_mouseover).
        on("mouseout", @node_mouseout)
      # link labels
      #
      links.append("svg:text").
      attr("class", "link_label").
      attr("x", (d) => @x d.right_x()).
      attr("y", (d) => @y d.right_y()).
      attr("dx", -55).
      attr("dy", 3).
      style("opacity", 0).
      text((d) => @format_value d.value())

      return links

    draw_nodes: =>
      # Node elements are grouped inside an svg element, so we can use relative
      # coordinates
      #
      # The container just stores the x and y coordinates
      #
      nodes = @svg.selectAll("svg.node").
        data(@module.nodes.models, (d) -> d.get('id')).
        enter().
        append("svg").
        attr("class", (d) -> "node").
        attr("data-id", (d) -> d.get('id')).
        attr("x", (d) => @x(@module.Node.horizontal_spacing * d.get('column'))).
        attr("y", (d) => @y(d.y_offset()))

      # The rectangle just cares about its size and color
      #
      colors = d3.scale.category20()

      nodes.append("svg:rect").
        attr("fill", (datum, i) -> colors(i)).
        attr("stroke", (d, i) -> d3.rgb(colors(i)).darker(2)).
        attr("width", (d) => @x @module.Node.width).
        attr("height", (d) => @y d.value()).
        on("mouseover", @node_mouseover).
        on("mouseout", @node_mouseout)

      # And here we have the label. We use a +svg:text+ element that will then
      # hold a +tspan+ element for each line
      #
      nodes.append("svg:text").
        attr("class", "label").
        attr("x", @x 30).
        attr("y", 9).
        text((d) -> d.label())

      return nodes

    # formats the value shown in the link labels
    #
    format_value: (x) -> "#{x.toFixed(2)} PJ"

    # callbacks
    #
    node_mouseover: ->
      klass = $(this).parent().attr('data-id')
      d3.selectAll(".link").
        filter((d) -> !d.connects(klass)).
        transition().
        duration(200).
        style("opacity", 0.2)

    # this is use ased link_mouseout, too
    node_mouseout: ->
      d3.selectAll(".link").
        transition().
        duration(200).
        style("opacity", 0.8).
        selectAll(".link_label").
        transition().
        style("opacity", 0)

    link_mouseover: ->
      current_id = $(this).parent().attr("data-cid")
      d3.selectAll(".link").
        each((d) ->
          item = d3.select(this)
          if d.cid == current_id
            item.selectAll(".link_label").
              transition().
              style("opacity", 1)
          else
            item.transition().
              duration(200).
              style("opacity", 0.2)
        )


    # this method is called every time we're updating the chart
    #
    refresh: =>
      max_height = @module.nodes.max_column_value()

      # update the scaling function
      #
      @y = d3.scale.linear().
        domain([0, max_height * 1.25]).
        range([0, @height * .90])

      # refresh the axis
      @svg.selectAll(".y").transition().duration(500).call(@y_axis.scale(@y))

      # start by translating the container to the final position
      #
      @nodes.data(@module.nodes.models, (d) -> d.get('id')).
        transition().duration(500).
        attr("y", (d) => @y(d.y_offset()))

      # then resize the rectangles
      #
      @nodes.data(@module.nodes.models, (d) -> d.get('id')).
        selectAll("rect").
        transition().duration(500).
        attr("height", (d) => @y d.value())

      # then move the label
      #
      @nodes.data(@module.nodes.models, (d) -> d.get('id')).
        selectAll("text.label").
        transition().duration(500).
        attr("dy", (d) => @y(d.value() / 2))

      # then transform the links
      #
      @links.data(@module.links.models, (d) -> d.cid).
        transition().duration(500).
        selectAll("path").
        attr("d", (link) => @link_line link.path_points()).
        style("stroke-width", (link) => @y(link.value()))

      # then move the labels and update their value
      #
      @links.data(@module.links.models, (d) -> d.cid).
        transition().duration(500).
        selectAll("text.link_label").
        attr("y", (link) => @y link.right_y()).
        text((d) => @format_value d.value())

class D3.sankey.NodeList extends Backbone.Collection
  model: D3.sankey.Node

  # returns the height of the tallest column
  #
  max_column_value: =>
    sums = {}
    @each (n) ->
      column = n.get 'column'
      sums[column] = sums[column] || 0
      sums[column] += n.value()
    _.max _.values(sums)

class D3.sankey.LinkList extends Backbone.Collection
  model: D3.sankey.Link

