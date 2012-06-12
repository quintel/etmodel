D3.mekko =
  data: {
    biomass: [
      {gquery: 'biomass_industry_in_mekko_of_final_demand',    label: 'biomass industry'},
      {gquery: 'biomass_households_in_mekko_of_final_demand',  label: 'biomass households'},
      {gquery: 'biomass_buildings_in_mekko_of_final_demand',   label: 'biomass buildings'},
      {gquery: 'biomass_transport_in_mekko_of_final_demand',   label: 'biomass transport'},
      {gquery: 'biomass_other_in_mekko_of_final_demand',       label: 'biomass other'},
      {gquery: 'biomass_agriculture_in_mekko_of_final_demand', label: 'biomass agriculture'}
    ],
    oil: [
      {gquery: 'oil_industry_in_mekko_of_final_demand',    label: 'oil industry', color: '#888'},
      {gquery: 'oil_households_in_mekko_of_final_demand',  label: 'oil households', color: '#777'},
      {gquery: 'oil_buildings_in_mekko_of_final_demand',   label: 'oil buildings', color: '#666'},
      {gquery: 'oil_transport_in_mekko_of_final_demand',   label: 'oil transport', color: '#555'},
      {gquery: 'oil_other_in_mekko_of_final_demand',       label: 'oil other', color: '#444'},
      {gquery: 'oil_agriculture_in_mekko_of_final_demand', label: 'oil agriculture', color: '#333'}
    ],
    gas: [
      {gquery: 'gas_industry_in_mekko_of_final_demand',    label: 'gas industry'},
      {gquery: 'gas_households_in_mekko_of_final_demand',  label: 'gas households'},
      {gquery: 'gas_buildings_in_mekko_of_final_demand',   label: 'gas buildings'},
      {gquery: 'gas_transport_in_mekko_of_final_demand',   label: 'gas transport'},
      {gquery: 'gas_other_in_mekko_of_final_demand',       label: 'gas other'},
      {gquery: 'gas_agriculture_in_mekko_of_final_demand', label: 'gas agriculture'}
    ],
    coal: [
      {gquery: 'coal_industry_in_mekko_of_final_demand',    label: 'coal industry'},
      {gquery: 'coal_households_in_mekko_of_final_demand',  label: 'coal households'},
      {gquery: 'coal_buildings_in_mekko_of_final_demand',   label: 'coal buildings'},
      {gquery: 'coal_transport_in_mekko_of_final_demand',   label: 'coal transport'},
      {gquery: 'coal_other_in_mekko_of_final_demand',       label: 'coal other'},
      {gquery: 'coal_agriculture_in_mekko_of_final_demand', label: 'coal agriculture'}
    ],
    waste: [
      {gquery: 'waste_industry_in_mekko_of_final_demand'   , label: 'waste industry'},
      {gquery: 'waste_households_in_mekko_of_final_demand' , label: 'waste households'},
      {gquery: 'waste_buildings_in_mekko_of_final_demand'  , label: 'waste buildings'},
      {gquery: 'waste_transport_in_mekko_of_final_demand'  , label: 'waste transport'},
      {gquery: 'waste_other_in_mekko_of_final_demand'      , label: 'waste other'},
      {gquery: 'waste_agriculture_in_mekko_of_final_demand', label: 'waste agriculture'}
    ],
    biofuels: [
      {gquery: 'bio_fuels_industry_in_mekko_of_final_demand',    label: 'biofuels industry'},
      {gquery: 'bio_fuels_households_in_mekko_of_final_demand',  label: 'biofuels households'},
      {gquery: 'bio_fuels_buildings_in_mekko_of_final_demand',   label: 'biofuels buildings'},
      {gquery: 'bio_fuels_transport_in_mekko_of_final_demand',   label: 'biofuels transport'},
      {gquery: 'bio_fuels_other_in_mekko_of_final_demand',       label: 'biofuels other'},
      {gquery: 'bio_fuels_agriculture_in_mekko_of_final_demand', label: 'biofuels agriculture'}
    ],
    electricity: [
      {gquery: 'electricity_industry_in_mekko_of_final_demand',    label: 'electricity industry'},
      {gquery: 'electricity_households_in_mekko_of_final_demand',  label: 'electricity households'},
      {gquery: 'electricity_buildings_in_mekko_of_final_demand',   label: 'electricity buildings'},
      {gquery: 'electricity_transport_in_mekko_of_final_demand',   label: 'electricity transport'},
      {gquery: 'electricity_other_in_mekko_of_final_demand',       label: 'electricity other'},
      {gquery: 'electricity_agriculture_in_mekko_of_final_demand', label: 'electricity agriculture'}
    ],
    hot_water: [
      {gquery: 'hot_water_industry_in_mekko_of_final_demand',    label: 'hot water industry'},
      {gquery: 'hot_water_households_in_mekko_of_final_demand',  label: 'hot water households'},
      {gquery: 'hot_water_buildings_in_mekko_of_final_demand',   label: 'hot water buildings'},
      {gquery: 'hot_water_transport_in_mekko_of_final_demand',   label: 'hot water transport'},
      {gquery: 'hot_water_other_in_mekko_of_final_demand',       label: 'hot water other'},
      {gquery: 'hot_water_agriculture_in_mekko_of_final_demand', label: 'hot water agriculture'}
    ],
  }

  Node: class extends Backbone.Model
    initialize: ->
      @gquery = gqueries.find_or_create_by_key @get('gquery')

    # value is apparently a reserved name
    val: =>
      @gquery.get('future_value')

    label: => @get('label') || @get('gquery')

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @initialize_defaults()
      @color = d3.scale.category20c()
      @prepare_data()

    # D3 layouts expect data in a precise format
    prepare_data: =>
      return @out if @out
      out =
        name: "mekko"
        children: []
      for own key, values of D3.mekko.data
        group =
          name: key
          children: []
        for item in values
          group.children.push(new D3.mekko.Node(item))
        out.children.push group
      @out = out

    draw: =>
      @width = @container_node().width()   || 490
      @height = @container_node().height() || 502
      @treemap = d3.layout.treemap()
        .size([@width, @height])
        .sticky(true)
        .value((d) -> d.val())
      @svg = d3.select("#d3_container_mekko").
        append("div").
        style("position", "relative").
        style("height", "#{@height}px").
        style("width", "#{@width}px")
      @svg.data([@prepare_data()]).selectAll("div").
        data(@treemap.nodes).
        enter().
        append("div").
        attr("class", "cell").
        attr("title", (d) -> d.label() unless d.children).
        style("background", (d, i) =>
          if d.children
            null
          else
            d.get('color') || @color(i)).
        text((d) -> if d.children then null else d.label()).
        on('mouseover', ->
          item = d3.select(this)
          old_color = item.style("background")
          # TODO: figure out if there's a better way to save the old value
          item.attr("data-old_color", old_color)
          item.transition().
          style("background", "red")
        ).
        on('mouseout', ->
          item = d3.select(this)
          item.transition().
          style("background", item.attr('data-old_color'))
        ).
        call(@cell)

        $("div.cell").tipsy
          html: true

    refresh: =>
      @svg.selectAll("div").
        data(@treemap.value( (d) ->
          d.val()
        )).
        attr("title", (d) ->
          # used by tipsy
          return if d.children
          val = d.val().toFixed(2)
          "#{d.label()}<br/>#{val}PJ"
          ).
        transition().
        duration(500).
        call(@cell)

    cell: ->
      @style 'left', (d) -> "#{d.x}px"
      @style 'top', (d) -> "#{d.y}px"
      @style 'width', (d) -> Math.max(0, d.dx - 1) + "px"
      @style 'height', (d) -> Math.max(0, d.dy - 1) + "px"



