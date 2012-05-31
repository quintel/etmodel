D3.mekko =
  data: {
    biomass: [
      {gquery: 'biomass_industry_in_mekko_of_final_demand'},
      {gquery: 'biomass_households_in_mekko_of_final_demand'},
      {gquery: 'biomass_buildings_in_mekko_of_final_demand'},
      {gquery: 'biomass_transport_in_mekko_of_final_demand'},
      {gquery: 'biomass_other_in_mekko_of_final_demand'},
      {gquery: 'biomass_agriculture_in_mekko_of_final_demand'}
    ],
    oil: [
      {gquery: 'oil_industry_in_mekko_of_final_demand'},
      {gquery: 'oil_households_in_mekko_of_final_demand'},
      {gquery: 'oil_buildings_in_mekko_of_final_demand'},
      {gquery: 'oil_transport_in_mekko_of_final_demand'},
      {gquery: 'oil_other_in_mekko_of_final_demand'},
      {gquery: 'oil_agriculture_in_mekko_of_final_demand'}
    ],
    gas: [
      {gquery: 'gas_industry_in_mekko_of_final_demand'},
      {gquery: 'gas_households_in_mekko_of_final_demand'},
      {gquery: 'gas_buildings_in_mekko_of_final_demand'},
      {gquery: 'gas_transport_in_mekko_of_final_demand'},
      {gquery: 'gas_other_in_mekko_of_final_demand'},
      {gquery: 'gas_agriculture_in_mekko_of_final_demand'}
    ],
    coal: [
      {gquery: 'coal_industry_in_mekko_of_final_demand'},
      {gquery: 'coal_households_in_mekko_of_final_demand'},
      {gquery: 'coal_buildings_in_mekko_of_final_demand'},
      {gquery: 'coal_transport_in_mekko_of_final_demand'},
      {gquery: 'coal_other_in_mekko_of_final_demand'},
      {gquery: 'coal_agriculture_in_mekko_of_final_demand'}
    ],
    waste: [
      {gquery: 'waste_industry_in_mekko_of_final_demand'},
      {gquery: 'waste_households_in_mekko_of_final_demand'},
      {gquery: 'waste_buildings_in_mekko_of_final_demand'},
      {gquery: 'waste_transport_in_mekko_of_final_demand'},
      {gquery: 'waste_other_in_mekko_of_final_demand'},
      {gquery: 'waste_agriculture_in_mekko_of_final_demand'}
    ],
    biofuels: [
      {gquery: 'bio_fuels_industry_in_mekko_of_final_demand'},
      {gquery: 'bio_fuels_households_in_mekko_of_final_demand'},
      {gquery: 'bio_fuels_buildings_in_mekko_of_final_demand'},
      {gquery: 'bio_fuels_transport_in_mekko_of_final_demand'},
      {gquery: 'bio_fuels_other_in_mekko_of_final_demand'},
      {gquery: 'bio_fuels_agriculture_in_mekko_of_final_demand'}
    ],
    electricity: [
      {gquery: 'electricity_industry_in_mekko_of_final_demand'},
      {gquery: 'electricity_households_in_mekko_of_final_demand'},
      {gquery: 'electricity_buildings_in_mekko_of_final_demand'},
      {gquery: 'electricity_transport_in_mekko_of_final_demand'},
      {gquery: 'electricity_other_in_mekko_of_final_demand'},
      {gquery: 'electricity_agriculture_in_mekko_of_final_demand'}
    ],
    hot_water: [
      {gquery: 'hot_water_industry_in_mekko_of_final_demand'},
      {gquery: 'hot_water_households_in_mekko_of_final_demand'},
      {gquery: 'hot_water_buildings_in_mekko_of_final_demand'},
      {gquery: 'hot_water_transport_in_mekko_of_final_demand'},
      {gquery: 'hot_water_other_in_mekko_of_final_demand'},
      {gquery: 'hot_water_agriculture_in_mekko_of_final_demand'}
    ],
  }

  Node: class extends Backbone.Model
    initialize: ->
      @gquery = new Gquery({key: @get('gquery')})

    # value is apparently a reserved name
    val: =>
      @gquery.get('future_value')

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @initialize_defaults()
      @color = d3.scale.category20c()

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
        .value((d) -> 1);
      @svg = d3.select("#d3_container").
        append("div").
        style("position", "relative").
        style("height", "#{@height}px").
        style("width", "#{@width}px")
      @svg.data([@prepare_data()]).selectAll("div").
        data(@treemap.nodes).
        enter().
        append("div").
        attr("class", "cell").
        style("background", (d, i) => @color(i)).
        text((d) -> if d.children then null else d.get('gquery')).
        call(@cell)

    refresh: =>
      @svg.selectAll("div").
        data(@treemap.value( (d) ->
          d.val()
        )).
        transition().
        duration(500).
        call(@cell)

    cell: ->
      @style 'left', (d) -> "#{d.x}px"
      @style 'top', (d) -> "#{d.y}px"
      @style 'width', (d) -> Math.max(0, d.dx - 1) + "px"
      @style 'height', (d) -> Math.max(0, d.dy - 1) + "px"


