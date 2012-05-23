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
    @width: 170
    @horizontal_spacing: 400

    # vertical position of the node. Adds some margin between nodes
    #
    y_offset: =>
      offset = 0
      margin = 35
      for n in @siblings()
        break if n == this
        offset += n.value() + margin
      offset

    x_offset: => @get('column') * D3.sankey.Node.horizontal_spacing + 20
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

    initialize: =>
      # shortcut to access the collection objects
      @module = D3.sankey
      @right_links = []
      @left_links = []

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
        @gquery = new Gquery({key: @get('gquery')})
      # let the nodes know about me
      @left.right_links.push this
      @right.left_links.push this

    # returns the absolute y coordinate of the left anchor point
    #
    # This method should definitely be simplifiwed
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
          x: @left_x()
          y: @left_y()
        ,
          x: @left_x() + 80
          y: @left_y()
        ,
          x: @right_x() - 80
          y: @right_y()
        ,
          x: @right_x()
          y: @right_y()
      ]

    value: =>
      if @gquery
        @gquery.get('future_value') / 4
      else
        10

    color: => @get('color') || "steelblue"

  # This is the main chart class
  #
  View: class extends D3ChartView
    el: "body"

    draw: =>
      @svg = d3.select("#d3_container").
        append("svg:svg").
        attr("height", @height).
        attr("width", @width)

      colors = d3.scale.category20()
      link_color = d3.scale.category20()

      @links = @svg.selectAll('path.link').
        data(@module.links.models, (d) -> d.cid).
        enter().
        append("svg:path").
        attr("class", "link").
        style("stroke-width", (link) -> link.value()).
        style("stroke", (link, i) -> link.color()).
        #style("stroke", (link, i) -> link_color(i)).
        style("fill", "none").
        style("opacity", 0.8).
        attr("d", (link) => @link_line link.path_points())

      @nodes = @svg.selectAll("rect").
        data(@module.nodes.models, (d) -> d.get('id')).
        enter().
        append("rect").
        attr("x", (d) => @x(@module.Node.horizontal_spacing * d.get('column') + 20)).
        attr("y", (d) => @y(d.y_offset())).
        attr("width", @x @module.Node.width).
        attr("height", (d) => @y d.value()).
        attr("stroke", "gray").
        attr("fill", (datum, i) -> colors(i))

      @labels = @svg.selectAll("text.label").
        data(@module.nodes.models, (d) -> d.get('id')).
        enter().
        append("svg:text").
        attr("class", "label").
        attr("x", (d) => @x d.x_offset()).
        attr("y", (d) => @y(d.y_center() + 5)).
        attr("dx", 5).
        text((d) -> d.label())

    refresh: =>
      @nodes.data(@module.nodes.models, (d) -> d.get('id')).
        transition().duration(500).
        attr("height", (d) => @y d.value()).
        attr("y", (d) => @y d.y_offset())

      @labels.data(@module.nodes.models, (d) -> d.get('id')).
        transition().duration(500).
        attr("y", (d) => @y(d.y_center() + 5))

      @links.data(@module.links.models, (d) -> d.cid).
        transition().duration(500).
        attr("d", (link) => @link_line link.path_points()).
        style("stroke-width", (link) => @y(link.value()))

    initialize: ->
      @module = D3.sankey
      @module.nodes = new @module.NodeList(@module.data.nodes)
      @module.links = new @module.LinkList(@module.data.links)
      @initialize_defaults()
      @x = d3.scale.linear().
        domain([0, 1000]).
        range([0, @width])

      @y = d3.scale.linear().
        domain([0, 700]).
        range([0, @height])

      # This is the function that will take care of drawing the links once we've
      # set the base points
      @link_line = d3.svg.line().
        interpolate("basis").
        x((d) -> @x(d.x)).
        y((d) -> @y(d.y))

class D3.sankey.NodeList extends Backbone.Collection
  model: D3.sankey.Node

class D3.sankey.LinkList extends Backbone.Collection
  model: D3.sankey.Link

