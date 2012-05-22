D3.sankey =
  data :
    nodes: [
      {id: 'households',  column: 0, row: 0},
      {id: 'buildings',   column: 0, row: 1},
      {id: 'transport',   column: 0, row: 2},
      {id: 'industry',    column: 0, row: 3},
      {id: 'agriculture', column: 0, row: 4},
      {id: 'other',       column: 0, row: 5},
      {id: 'loss',        column: 0, row: 6},

      {id: 'el_prod',     column: 1, row: 1, label: "electricity production"},
      {id: 'heat_prod',   column: 1, row: 3, label: "heating production"},

      {id: 'coal',        column: 2, row: 0},
      {id: 'nuclear',     column: 2, row: 1},
      {id: 'gas',         column: 2, row: 2},
      {id: 'oil',         column: 2, row: 3},
      {id: 'biomass',     column: 2, row: 4},
      {id: 'wind',        column: 2, row: 5},
      {id: 'hydro',       column: 2, row: 6},
      {id: 'solar',       column: 2, row: 7},
      {id: 'waste',       column: 2, row: 8}

    ]
    links: [
      {left: 'industry',    right: 'el_prod',   gquery: 'electricity_industry_in_mekko_of_final_demand'},
      {left: 'other',       right: 'el_prod',   gquery: 'electricity_other_in_mekko_of_final_demand'},
      {left: 'households',  right: 'el_prod',   gquery: 'electricity_households_in_mekko_of_final_demand'},
      {left: 'agriculture', right: 'el_prod',   gquery: 'electricity_agriculture_in_mekko_of_final_demand'},
      {left: 'buildings',   right: 'el_prod',   gquery: 'electricity_buildings_in_mekko_of_final_demand'},
      {left: 'transport',   right: 'el_prod',   gquery: 'electricity_transport_in_mekko_of_final_demand'},
      {left: 'industry',    right: 'heat_prod', gquery: 'hot_water_industry_in_mekko_of_final_demand'},
      {left: 'other',       right: 'heat_prod', gquery: 'hot_water_other_in_mekko_of_final_demand'},
      {left: 'households',  right: 'heat_prod', gquery: 'hot_water_households_in_mekko_of_final_demand'},
      {left: 'agriculture', right: 'heat_prod', gquery: 'hot_water_agriculture_in_mekko_of_final_demand'},
      {left: 'buildings',   right: 'heat_prod', gquery: 'hot_water_buildings_in_mekko_of_final_demand'},
      {left: 'transport',   right: 'heat_prod', gquery: 'hot_water_transport_in_mekko_of_final_demand'},
      {left: 'el_prod',     right: 'coal',      gquery: 'coal_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'nuclear',   gquery: 'nuclear_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'gas',       gquery: 'gas_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'oil',       gquery: 'oil_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'biomass',   gquery: 'biomass_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'wind',      gquery: 'wind_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'hydro',     gquery: 'hydro_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'solar',     gquery: 'solar_in_source_of_electricity_production'},
      {left: 'el_prod',     right: 'waste',     gquery: 'waste_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'coal',      gquery: 'coal_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'nuclear',   gquery: 'nuclear_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'gas',       gquery: 'gas_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'oil',       gquery: 'oil_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'biomass',   gquery: 'biomass_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'wind',      gquery: 'wind_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'hydro',     gquery: 'hydro_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'solar',     gquery: 'solar_in_source_of_electricity_production'},
      {left: 'heat_prod',   right: 'waste',     gquery: 'waste_in_source_of_electricity_production'}
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
        #style("stroke", (link, i) -> link.color()).
        style("stroke", (link, i) -> link_color(i)).
        style("fill", "none").
        style("opacity", 0.8).
        on('mouseover', ->
          d3.select(this).transition().duration(900).style("stroke", "red")
        ).
        on('mouseout', ->
          d3.select(this).transition().duration(200).style("stroke", "steelblue")
        ).
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

