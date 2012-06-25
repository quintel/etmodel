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
    {left: 'electricity',      right: 'households', gquery: 'electricity_to_households_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'households', gquery: 'heat_to_households_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'households', gquery: 'distribution_to_households_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'buildings', gquery: 'electricity_to_buildings_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'buildings', gquery: 'heat_to_buildings_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'buildings', gquery: 'distribution_to_buildings_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'agriculture', gquery: 'electricity_to_agriculture_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'agriculture', gquery: 'heat_to_agriculture_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'agriculture', gquery: 'distribution_to_agriculture_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'transport', gquery: 'electricity_to_transport_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'transport', gquery: 'heat_to_transport_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'transport', gquery: 'distribution_to_transport_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'industry', gquery: 'electricity_to_industry_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'industry', gquery: 'heat_to_industry_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'industry', gquery: 'distribution_to_industry_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'other', gquery: 'electricity_to_other_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'other', gquery: 'heat_to_other_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'other', gquery: 'distribution_to_other_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'monetized_heat', gquery: 'monetized_heat_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'electricity', gquery: 'electricity_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'useful_demand', gquery: 'useful_demand_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'non_renewable_waste', gquery: 'non_renewable_waste_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'geo_solar_wind_water_ambient', gquery: 'geo_solar_wind_water_ambient_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'natural_gas', gquery: 'natural_gas_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'nuclear', gquery: 'nuclear_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'biomass_products', gquery: 'biomass_products_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'electricity',      right: 'mixed_flows', gquery: 'mixed_flows_to_electricity_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'monetized_heat', gquery: 'monetized_heat_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'electricity', gquery: 'electricity_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'useful_demand', gquery: 'useful_demand_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'non_renewable_waste', gquery: 'non_renewable_waste_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'geo_solar_wind_water_ambient', gquery: 'geo_solar_wind_water_ambient_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'natural_gas', gquery: 'natural_gas_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'nuclear', gquery: 'nuclear_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'biomass_products', gquery: 'biomass_products_to_heat_in_sankey.gql', color: 'black'},
    {left: 'heat',      right: 'mixed_flows', gquery: 'mixed_flows_to_heat_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'monetized_heat', gquery: 'monetized_heat_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'electricity', gquery: 'electricity_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'useful_demand', gquery: 'useful_demand_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'non_renewable_waste', gquery: 'non_renewable_waste_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'geo_solar_wind_water_ambient', gquery: 'geo_solar_wind_water_ambient_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'natural_gas', gquery: 'natural_gas_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'nuclear', gquery: 'nuclear_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'biomass_products', gquery: 'biomass_products_to_distribution_in_sankey.gql', color: 'black'},
    {left: 'distribution',      right: 'mixed_flows', gquery: 'mixed_flows_to_distribution_in_sankey.gql', color: 'black'}

    ]

  # In this chart most positioning is calculated by us. The D3 sankey plugin is
  # cool but not flexible enough
  Node: class extends Backbone.Model
    @width: 25
    @horizontal_spacing: 280
    vertical_margin: 8

    initialize: =>
      @view = D3.sankey.view
      @right_links = []
      @left_links = []

    # vertical position of the top left corner of the node. Adds some margin
    # between nodes
    y_offset: =>
      offset = 0
      # since the value's going to be scaled, let's invert it to have always the
      # same margin in absolute (=pixel) values
      margin = @view.y.invert(@vertical_margin)
      for n in @siblings()
        break if n == this
        offset += n.value() + margin
      offset

    x_offset: => @get('column') * D3.sankey.Node.horizontal_spacing

    # center point of the node. We use it as link anchor point
    x_center: => @x_offset() + D3.sankey.Node.width / 2

    # The height of the node is the sum of the height of its link. Since links
    # are both inbound and outbound, let's use the max size. Ideally the values
    # should match
    value: =>
      _.max [
        _.inject(@left_links, ((memo, i) -> memo + i.value()), 0),
        _.inject(@right_links,((memo, i) -> memo + i.value()), 0)
      ]

    # returns an array of the other nodes that belong to the same column. This
    # is used by the +y_offset+ method to calculate the right node position
    siblings: =>
      items = _.groupBy(@view.node_list.models, (node) -> node.get('column'))
      items[@get 'column']

    label: => @get('label') || @get('id')

  Link: class extends Backbone.Model
    initialize: =>
      @view = D3.sankey.view
      @series = @view.series
      @left = @view.node_list.get @get('left')
      @right = @view.node_list.get @get('right')
      if @get('gquery')
        @gquery = new ChartSerie
          gquery_key: @get('gquery')
        @series.push(@gquery)
      # let the nodes know about me
      @left.right_links.push this
      @right.left_links.push this

    # returns the absolute y coordinate of the left anchor point. SVG wants the
    # anchor point of the line middle, so we must take into account the stroke
    # width. This method is ugly and should definitely be simplified
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

    right_y:  =>
      offset = null
      for link in @right.left_links
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

    left_x:  => @left.x_center()  + D3.sankey.Node.width / 2
    right_x: => @right.x_center() - D3.sankey.Node.width / 2

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
        x = @gquery.future_value()
      if _.isNumber(x) then x else 0

    color: => @get('color') || "steelblue"

    connects: (id) => @get('left') == id || @get('right') == id

  # This is the main chart class
  #
  View: class extends D3ChartView
    initialize: ->
      namespace = D3.sankey
      namespace.view = this
      @series = @model.series
      @node_list = new namespace.NodeList(namespace.data.nodes)
      @link_list = new namespace.LinkList(namespace.data.links)
      @initialize_defaults()

    # this method is called when we first render the chart. It is called if we
    # want a full chart refresh when the user resizes the browser window, too
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
        attr("class", "y_axis").
        attr("transform", "translate(-10, 0)").
        call(@y_axis)

    draw_links: =>
      # links are treated as a group made of a link path and label text element
      links = @svg.selectAll('g.link').
        data(@link_list.models, (d) -> d.cid).
        enter().
        append("svg:g").
        attr("class", (l) -> "link #{l.left.get('id')} #{l.right.get('id')}").
        attr("data-cid", (d) -> d.cid) # unique identifier
      # link path
      links.append("svg:path").
        style("stroke-width", (link) -> link.value()).
        style("stroke", (link, i) -> link.color()).
        style("fill", "none").
        style("opacity", 0.8).
        attr("d", (link) => @link_line link.path_points()).
        on("mouseover", @link_mouseover).
        on("mouseout", @node_mouseout)
      # link labels
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
      horizontal_spacing = D3.sankey.Node.horizontal_spacing
      width = D3.sankey.Node.width
      colors = d3.scale.category20()
      nodes = @svg.selectAll("g.node").
        data(@node_list.models, (d) -> d.get('id')).
        enter().
        append("g").
        attr("class", "node").
        attr("data-id", (d) -> d.get('id'))

      nodes.append("svg:rect").
        attr("x", (d) => @x(horizontal_spacing * d.get('column'))).
        attr("y", (d) => @y(d.y_offset())).
        attr("fill", (datum, i) -> colors(i)).
        attr("stroke", (d, i) -> d3.rgb(colors(i)).darker(2)).
        attr("width", (d) => @x width).
        attr("height", (d) => @y d.value()).
        on("mouseover", @node_mouseover).
        on("mouseout", @node_mouseout)

      nodes.append("svg:text").
        attr("class", "label").
        attr("x", (d) => @x d.x_offset()).
        attr("dx", 20).
        attr("dy", 3).
        attr("y", (d) => @y(d.y_offset() + d.value() / 2) ).
        text((d) -> d.label())

      return nodes

    # formats the value shown in the link labels
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

    # this is used as link_mouseout, too
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
        each (d) ->
          item = d3.select(this)
          if d.cid == current_id
            item.selectAll(".link_label").transition().style("opacity", 1)
          else
            item.transition().duration(200).style("opacity", 0.2)

    # this method is called every time we're updating the chart
    refresh: =>
      max_height = @node_list.max_column_value()

      # update the scaling function
      @y = d3.scale.linear().
        domain([0, max_height * 1.25]).
        range([0, @height * .90])

      # refresh the axis
      @svg.selectAll(".y_axis").transition().duration(500).call(@y_axis.scale(@y))

      # move the rectangles
      @nodes.data(@node_list.models, (d) -> d.get('id')).
        selectAll("rect").
        transition().duration(500).
        attr("height", (d) => @y d.value()).
        attr("y", (d) => @y(d.y_offset()))

      # then move the node label
      @nodes.data(@node_list.models, (d) -> d.get('id')).
        selectAll("text.label").
        transition().duration(500).
        attr("y", (d) => @y(d.y_offset() + d.value() / 2) )

      # then transform the links
      @links.data(@link_list.models, (d) -> d.cid).
        transition().duration(500).
        selectAll("path").
        attr("d", (link) => @link_line link.path_points()).
        style("stroke-width", (link) => @y(link.value()))

      # then move the link labels and update their value
      @links.data(@link_list.models, (d) -> d.cid).
        transition().duration(500).
        selectAll("text.link_label").
        attr("y", (link) => @y link.right_y()).
        text((d) => @format_value d.value())

class D3.sankey.NodeList extends Backbone.Collection
  model: D3.sankey.Node

  # returns the height of the tallest column
  max_column_value: =>
    sums = {}
    @each (n) ->
      column = n.get 'column'
      sums[column] = sums[column] || 0
      sums[column] += n.value()
    _.max _.values(sums)

class D3.sankey.LinkList extends Backbone.Collection
  model: D3.sankey.Link
