D3.primary_final_useful_demand =
  data :
    nodes: [

      {id: 'coal_and_derivatives',     column: 0, label: "coal", color: 'yellow'},
      {id: 'oil_and_derivatives',        column: 0, label: "oil"},
      #{id: 'useful_demand',         column: 0},
      #{id: 'non_renewable_waste',         column: 0},
      #{id: 'geo_solar_wind_water_ambient',     column: 0},
      {id: 'natural_gas',        column: 0, label: "gas"},
      {id: 'nuclear',       column: 0, label: "nuclear"},
      {id: 'biomass_products',       column: 0, label: "biomass"},
      #{id: 'mixed_flows',       column: 0, label: "mixed flows"},
      {id: 'electricity',       column: 0, label: "renewable electricity"},
      {id: 'imported_electricity',       column: 0, label: "imported electricity"},

      {id: 'households',  column: 1},
      {id: 'buildings',   column: 1},
      {id: 'agriculture', column: 1},
      {id: 'transport',   column: 1},
      {id: 'industry',    column: 1},
      {id: 'other',       column: 1},
      {id: 'exported_electricity',       column: 1},

      {id: 'useful_demand_electric',     column: 2, label: "electricity"},
      {id: 'useful_demand_heat_cold',   column: 2, label: "heat/cold"},
      {id: 'useful_demand_transport',   column: 2, label: "transport"},
      {id: 'useful_demand_non_energetic',   column: 2, label: "non-energetic"},

    ]
    links: [
      #Direct links between carrier and sector
      {left: 'coal_and_derivatives',      right: 'households', gquery: 'coal_and_derivatives_to_households_in_sankey_ufp', color: 'black'},
      {left: 'oil_and_derivatives',      right: 'households', gquery: 'oil_and_derivatives_to_households_in_sankey_ufp', color: 'brown'},
      {left: 'natural_gas',      right: 'households', gquery: 'natural_gas_to_households_in_sankey_ufp', color: 'steelblue'},
      {left: 'nuclear',      right: 'households', gquery: 'nuclear_to_households_in_sankey_ufp', color: 'black'},
      {left: 'biomass_products',      right: 'households', gquery: 'biomass_products_to_households_in_sankey_ufp', color: 'green'},
      {left: 'imported_electricity',      right: 'households', gquery: 'imported_electricity_to_households_in_sankey_ufp', color: 'blue'},
      {left: 'electricity',      right: 'households', gquery: 'electricity_to_households_in_sankey_ufp', color: 'black'},
      {left: 'coal_and_derivatives',      right: 'buildings', gquery: 'coal_and_derivatives_to_buildings_in_sankey_ufp', color: 'black'},
      {left: 'oil_and_derivatives',      right: 'buildings', gquery: 'oil_and_derivatives_to_buildings_in_sankey_ufp', color: 'brown'},
      {left: 'natural_gas',      right: 'buildings', gquery: 'natural_gas_to_buildings_in_sankey_ufp', color: 'steelblue'},
      {left: 'nuclear',      right: 'buildings', gquery: 'nuclear_to_buildings_in_sankey_ufp', color: 'black'},
      {left: 'biomass_products',      right: 'buildings', gquery: 'biomass_products_to_buildings_in_sankey_ufp', color: 'green'},
      {left: 'imported_electricity',      right: 'buildings', gquery: 'imported_electricity_to_buildings_in_sankey_ufp', color: 'blue'},
      {left: 'electricity',      right: 'buildings', gquery: 'electricity_to_buildings_in_sankey_ufp', color: 'black'},
      {left: 'coal_and_derivatives',      right: 'agriculture', gquery: 'coal_and_derivatives_to_agriculture_in_sankey_ufp', color: 'black'},
      {left: 'oil_and_derivatives',      right: 'agriculture', gquery: 'oil_and_derivatives_to_agriculture_in_sankey_ufp', color: 'brown'},
      {left: 'natural_gas',      right: 'agriculture', gquery: 'natural_gas_to_agriculture_in_sankey_ufp', color: 'steelblue'},
      {left: 'nuclear',      right: 'agriculture', gquery: 'nuclear_to_agriculture_in_sankey_ufp', color: 'black'},
      {left: 'biomass_products',      right: 'agriculture', gquery: 'biomass_products_to_agriculture_in_sankey_ufp', color: 'green'},
      {left: 'imported_electricity',      right: 'agriculture', gquery: 'imported_electricity_to_agriculture_in_sankey_ufp', color: 'blue'},
      {left: 'electricity',      right: 'agriculture', gquery: 'electricity_to_agriculture_in_sankey_ufp', color: 'black'},
      {left: 'coal_and_derivatives',      right: 'transport', gquery: 'coal_and_derivatives_to_transport_in_sankey_ufp', color: 'black'},
      {left: 'oil_and_derivatives',      right: 'transport', gquery: 'oil_and_derivatives_to_transport_in_sankey_ufp', color: 'brown'},
      {left: 'natural_gas',      right: 'transport', gquery: 'natural_gas_to_transport_in_sankey_ufp', color: 'steelblue'},
      {left: 'nuclear',      right: 'transport', gquery: 'nuclear_to_transport_in_sankey_ufp', color: 'black'},
      {left: 'biomass_products',      right: 'transport', gquery: 'biomass_products_to_transport_in_sankey_ufp', color: 'green'},
      {left: 'imported_electricity',      right: 'transport', gquery: 'imported_electricity_to_transport_in_sankey_ufp', color: 'blue'},
      {left: 'electricity',      right: 'transport', gquery: 'electricity_to_transport_in_sankey_ufp', color: 'black'},
      {left: 'coal_and_derivatives',      right: 'industry', gquery: 'coal_and_derivatives_to_industry_in_sankey_ufp', color: 'black'},
      {left: 'oil_and_derivatives',      right: 'industry', gquery: 'oil_and_derivatives_to_industry_in_sankey_ufp', color: 'brown'},
      {left: 'natural_gas',      right: 'industry', gquery: 'natural_gas_to_industry_in_sankey_ufp', color: 'steelblue'},
      {left: 'nuclear',      right: 'industry', gquery: 'nuclear_to_industry_in_sankey_ufp', color: 'black'},
      {left: 'biomass_products',      right: 'industry', gquery: 'biomass_products_to_industry_in_sankey_ufp', color: 'green'},
      {left: 'imported_electricity',      right: 'industry', gquery: 'imported_electricity_to_industry_in_sankey_ufp', color: 'blue'},
      {left: 'electricity',      right: 'industry', gquery: 'electricity_to_industry_in_sankey_ufp', color: 'black'},
      {left: 'coal_and_derivatives',      right: 'other', gquery: 'coal_and_derivatives_to_other_in_sankey_ufp', color: 'black'},
      {left: 'oil_and_derivatives',      right: 'other', gquery: 'oil_and_derivatives_to_other_in_sankey_ufp', color: 'brown'},
      {left: 'natural_gas',      right: 'other', gquery: 'natural_gas_to_other_in_sankey_ufp', color: 'steelblue'},
      {left: 'nuclear',      right: 'other', gquery: 'nuclear_to_other_in_sankey_ufp', color: 'black'},
      {left: 'biomass_products',      right: 'other', gquery: 'biomass_products_to_other_in_sankey_ufp', color: 'green'},
      {left: 'imported_electricity',      right: 'other', gquery: 'imported_electricity_to_other_in_sankey_ufp', color: 'blue'},
      {left: 'electricity',      right: 'other', gquery: 'electricity_to_other_in_sankey_ufp', color: 'black'},
      {left: 'households',      right: 'useful_demand_electric', gquery: 'households_to_useful_demand_electric_in_sankey_ufp', color: 'blue'},
      {left: 'households',      right: 'useful_demand_heat_cold', gquery: 'households_to_useful_demand_heat_cold_in_sankey_ufp', color: 'red'},
      {left: 'households',      right: 'useful_demand_transport', gquery: 'households_to_useful_demand_transport_in_sankey_ufp', color: 'green'},
      {left: 'households',      right: 'useful_demand_non_energetic', gquery: 'households_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
      {left: 'buildings',      right: 'useful_demand_electric', gquery: 'buildings_to_useful_demand_electric_in_sankey_ufp', color: 'blue'},
      {left: 'buildings',      right: 'useful_demand_heat_cold', gquery: 'buildings_to_useful_demand_heat_cold_in_sankey_ufp', color: 'red'},
      {left: 'buildings',      right: 'useful_demand_transport', gquery: 'buildings_to_useful_demand_transport_in_sankey_ufp', color: 'green'},
      {left: 'buildings',      right: 'useful_demand_non_energetic', gquery: 'buildings_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
      {left: 'agriculture',      right: 'useful_demand_electric', gquery: 'agriculture_to_useful_demand_electric_in_sankey_ufp', color: 'blue'},
      {left: 'agriculture',      right: 'useful_demand_heat_cold', gquery: 'agriculture_to_useful_demand_heat_cold_in_sankey_ufp', color: 'red'},
      {left: 'agriculture',      right: 'useful_demand_transport', gquery: 'agriculture_to_useful_demand_transport_in_sankey_ufp', color: 'green'},
      {left: 'agriculture',      right: 'useful_demand_non_energetic', gquery: 'agriculture_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
      {left: 'transport',      right: 'useful_demand_electric', gquery: 'transport_to_useful_demand_electric_in_sankey_ufp', color: 'blue'},
      {left: 'transport',      right: 'useful_demand_heat_cold', gquery: 'transport_to_useful_demand_heat_cold_in_sankey_ufp', color: 'red'},
      {left: 'transport',      right: 'useful_demand_transport', gquery: 'transport_to_useful_demand_transport_in_sankey_ufp', color: 'green'},
      {left: 'transport',      right: 'useful_demand_non_energetic', gquery: 'transport_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
      {left: 'industry',      right: 'useful_demand_electric', gquery: 'industry_to_useful_demand_electric_in_sankey_ufp', color: 'blue'},
      {left: 'industry',      right: 'useful_demand_heat_cold', gquery: 'industry_to_useful_demand_heat_cold_in_sankey_ufp', color: 'red'},
      {left: 'industry',      right: 'useful_demand_transport', gquery: 'industry_to_useful_demand_transport_in_sankey_ufp', color: 'green'},
      {left: 'industry',      right: 'useful_demand_non_energetic', gquery: 'industry_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
      {left: 'other',      right: 'useful_demand_electric', gquery: 'other_to_useful_demand_electric_in_sankey_ufp', color: 'blue'},
      {left: 'other',      right: 'useful_demand_heat_cold', gquery: 'other_to_useful_demand_heat_cold_in_sankey_ufp', color: 'red'},
      {left: 'other',      right: 'useful_demand_transport', gquery: 'other_to_useful_demand_transport_in_sankey_ufp', color: 'green'},
      {left: 'other',      right: 'useful_demand_non_energetic', gquery: 'other_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
      {left: 'coal_and_derivatives',      right: 'exported_electricity', gquery: 'coal_and_derivatives_to_exported_electricity_in_sankey_ufp', color: 'black'},
      {left: 'oil_and_derivatives',      right: 'exported_electricity', gquery: 'oil_and_derivatives_to_exported_electricity_in_sankey_ufp', color: 'brown'},
      {left: 'natural_gas',      right: 'exported_electricity', gquery: 'natural_gas_to_exported_electricity_in_sankey_ufp', color: 'steelblue'},
      {left: 'nuclear',      right: 'exported_electricity', gquery: 'nuclear_to_exported_electricity_in_sankey_ufp', color: 'black'},
      {left: 'biomass_products',      right: 'exported_electricity', gquery: 'biomass_products_to_exported_electricity_in_sankey_ufp', color: 'green'},
      {left: 'imported_electricity',      right: 'exported_electricity', gquery: 'imported_electricity_to_exported_electricity_in_sankey_ufp', color: 'blue'},
      {left: 'electricity',      right: 'exported_electricity', gquery: 'electricity_to_exported_electricity_in_sankey_ufp', color: 'black'},
    ]

  # In this chart most positioning is calculated by us. The D3 sankey plugin is
  # cool but not flexible enough
  Node: class extends Backbone.Model
    @width: 110
    @horizontal_spacing: 250
    vertical_margin: 10

    initialize: =>
      @view = D3.primary_final_useful_demand.view
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

    x_offset: => @get('column') * D3.primary_final_useful_demand.Node.horizontal_spacing

    # center point of the node. We use it as link anchor point
    x_center: => @x_offset() + D3.primary_final_useful_demand.Node.width / 2

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
      @view = D3.primary_final_useful_demand.view
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

    left_x:  => @left.x_center()  + D3.primary_final_useful_demand.Node.width / 2
    right_x: => @right.x_center() - D3.primary_final_useful_demand.Node.width / 2

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
      namespace = D3.primary_final_useful_demand
      namespace.view = this
      @series = @model.series
      @node_list = new namespace.NodeList(namespace.data.nodes)
      @link_list = new namespace.LinkList(namespace.data.links)
      @initialize_defaults()

    # this method is called when we first render the chart. It is called if we
    # want a full chart refresh when the user resizes the browser window, too
    draw: =>
      @margin =
        top: 5
        left: 5
        bottom: 5
        right: 10
      @width = (@container_node().width()   || 490) - (@margin.left + @margin.right)
      @height = (@container_node().height() || 452) - (@margin.top + @margin.bottom)

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

      @svg = d3.select("#d3_container_primary_final_useful_demand").
        append("svg:svg").
        attr("height", @height + @margin.top + @margin.bottom).
        attr("width", @width + @margin.left + @margin.right).
        append("svg:g").
        attr("transform", "translate(#{@margin.left}, #{@margin.top})")
      @links = @draw_links()
      @nodes = @draw_nodes()
      $("g.node").qtip
        content:
          text: -> $(this).attr('title')
        show:
          event: 'mouseover' # silly IE
        hide:
          event: 'mouseout'  # silly IE


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
        style("opacity", selectedLinkOpacity).
        attr("d", (link) => @link_line link.path_points()).
        on("mouseover", @link_mouseover).
        on("mouseout", @node_mouseout)
      # link labels
      links.append("svg:text").
      attr("class", "link_label").
      attr("x", (d) => @x d.right_x()).
      attr("y", (d) => @y d.right_y()).
      attr("dx", -55).
      attr("dy", 2).
      style("opacity", 0)
      return links

    draw_nodes: =>
      horizontal_spacing = D3.primary_final_useful_demand.Node.horizontal_spacing
      width = D3.primary_final_useful_demand.Node.width
      colors = d3.scale.category20()
      nodes = @svg.selectAll("g.node").
        data(@node_list.models, (d) -> d.get('id')).
        enter().
        append("g").
        attr("class", "node").
        attr("data-id", (d) -> d.get('id')).
        on("mouseover", @node_mouseover).
        on("mouseout", @node_mouseout)

      nodes.append("svg:rect").
        attr("x", (d) => @x(horizontal_spacing * d.get('column'))).
        attr("y", (d) => @y(d.y_offset())).
        attr("fill", (d, i) -> d.get('color') || colors(i)).
        style("stroke", (d, i) -> d3.rgb(d.get('color') || colors(i)).darker(2)).
        style('stroke-width', 1).
        attr("width", (d) => @x width).
        attr("height", (d) => @y d.value())

      nodes.append("svg:text").
        attr("class", "label").
        attr("x", (d) => @x d.x_offset()).
        attr("dx", 5).
        attr("dy", 3).
        attr("y", (d) => @y(d.y_offset() + d.value() / 2) ).
        text((d) -> d.label())

      return nodes

    # callbacks
    #
    unselectedLinkOpacity = 0.1
    selectedLinkOpacity = 0.8

    node_mouseover: ->
      klass = $(this).attr('data-id')
      d3.selectAll(".link").
        filter((d) -> !d.connects(klass)).
        transition().
        duration(200).
        style("opacity", unselectedLinkOpacity)

    # this is used as link_mouseout, too
    node_mouseout: ->
      d3.selectAll(".link").
        transition().
        duration(200).
        style("opacity", selectedLinkOpacity).
        selectAll(".link_label").
        transition().
        style("opacity", 0) # labels

    link_mouseover: ->
      current_id = $(this).parent().attr("data-cid")
      d3.selectAll(".link").
        each (d) ->
          item = d3.select(this)
          if d.cid == current_id
            item.selectAll(".link_label").transition().style("opacity", 1)
          else
            item.transition().duration(200).style("opacity", unselectedLinkOpacity)

    # this method is called every time we're updating the chart
    refresh: =>
      max_height = @node_list.max_column_value()

      # update the scaling function
      @y = d3.scale.linear().
        domain([0, max_height * 1.25]).
        range([0, @height * .90])

      # update the node label
      @nodes.data(@node_list.models, (d) -> d.get('id')).
        attr("title", (d) => Metric.autoscale_value d.value(), 'PJ', 2)

      # move the rectangles
      @nodes.selectAll("rect").
        transition().duration(500).
        attr("height", (d) => @y d.value()).
        attr("y", (d) => @y(d.y_offset()))

      # then move the node label
      @nodes.selectAll("text.label").
        transition().duration(500).
        attr("y", (d) => @y(d.y_offset() + d.value() / 2) )

      # then transform the links
      @links.data(@link_list.models, (d) -> d.cid).
        transition().duration(500).
        selectAll("path").
        attr("d", (link) => @link_line link.path_points()).
        style("stroke-width", (link) => @y(link.value()))

      # then move the link labels and update their value
      @links.transition().duration(500).
        selectAll("text.link_label").
        attr("y", (link) => @y link.right_y()).
        text((d) => Metric.autoscale_value d.value(), 'PJ', 2)

class D3.primary_final_useful_demand.NodeList extends Backbone.Collection
  model: D3.primary_final_useful_demand.Node

  # returns the height of the tallest column
  max_column_value: =>
    sums = {}
    @each (n) ->
      column = n.get 'column'
      sums[column] = sums[column] || 0
      sums[column] += n.value()
    _.max _.values(sums)

class D3.primary_final_useful_demand.LinkList extends Backbone.Collection
  model: D3.primary_final_useful_demand.Link