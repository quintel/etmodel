D3.mekko =
  data:
    sectors: ['industry', 'households', 'buildings', 'transport', 'agriculture', 'other']
    carriers: ['biomass', 'oil', 'gas', 'coal', 'waste', 'biofuels', 'electricity', 'hot_water']

  # This represents a carrier within a sector
  Node: class extends Backbone.Model
    initialize: =>
      @gquery = new ChartSerie
        gquery_key: "#{@get 'carrier'}_#{@get 'sector'}_in_mekko_of_final_demand"
      D3.mekko.series.push @gquery
      @sector = D3.mekko.sector_list.find((s) => s.get('key') == @get('sector'))
      @carrier = D3.mekko.carrier_list.find((s) => s.get('key') == @get('carrier'))
      @sector.nodes.push this
      @carrier.nodes.push this

    # value is apparently a reserved name
    val:   => @gquery.future_value()
    label: => @get('label') || @get('gquery')
    key:   => "#{@get 'carrier'}_#{@get 'sector'}"
    tooltip_text: =>
      "#{@get 'carrier'} #{@get 'sector'}<br/>#{parseInt @val()}PJ"

  NodeGroup: class extends Backbone.Model
      initialize: ->
        @nodes = []

      total_value: =>
        total = 0
        total += n.val() for n in @nodes
        total

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      namespace = D3.mekko
      @sector_list = namespace.sector_list = new D3.mekko.GroupCollection()
      @carrier_list = namespace.carrier_list = new D3.mekko.GroupCollection()
      @node_list = namespace.node_list = new D3.mekko.NodeList()
      @initialize_defaults()
      @color = d3.scale.category20()
      namespace.series = @model.series
      @prepare_data()

    prepare_data: =>
      for sector in D3.mekko.data.sectors
        @sector_list.add
          key: sector
        for carrier in D3.mekko.data.carriers
          @carrier_list.add
            key: carrier
          @node_list.add
            sector: sector
            carrier: carrier

    draw: =>
      margins =
        top: 40
        bottom: 100
        left: 30
        right: 30

      @width = (@container_node().width()   || 490) - (margins.left + margins.right)
      @height = (@container_node().height() || 402) - (margins.top + margins.bottom)
      @svg = d3.select("#d3_container_mekko").
        append("svg:svg").
        attr("height", @height + margins.top + margins.bottom).
        attr("width", @width + margins.left + margins.right).
        append("svg:g").
        attr("transform", "translate(#{margins.left}, #{margins.top})")

      y_scale = d3.scale.linear().domain([100,0]).range([0, @height])
      @y_axis = d3.svg.axis().scale(y_scale).ticks(4).orient("left")
      # axis
      @svg.append("svg:g").
        attr("class", "y_axis").
        call(@y_axis)

      # Every sector is assigned a group element
      @sectors = @svg.selectAll("g.sector").
        data(@sector_list.models, (d) -> d.get 'key' ).
        enter().append("svg:g").
        attr("class", "sector").
        attr("transform", (d) -> "translate(30)").
        attr("data-rel", (d) -> d.get 'key')

      # Create items inside the group
      @sectors.selectAll(".carrier").
        data( ((d) -> d.nodes) , ((d) -> d.key()) ).
        enter().append("svg:rect").
        attr("class", "carrier").
        attr("height", 10).
        attr("width", 10).
        style("fill", (d,i) => @color(i)).
        attr("y", 10).
        attr("x", 0).
        attr("data-rel", (d) -> d.key())



      # add legend
      legend = @svg.selectAll("svg.legend").
        data(D3.mekko.data.carriers).
        enter().
        append("svg:svg").
        attr("class", "legend").
        attr("x", (d, i) -> 100 * (i % 4) + 10).
        attr("y", (d, i) -> 18 * Math.floor(i / 4) - 36).
        attr("height", 30).
        attr("width", 90)

      legend.append("svg:rect").
        attr("width", 10).
        attr("height", 10).
        attr("fill", (d, i) => @color(i))
      legend.append("svg:text").
        text((d) -> I18n.t "output_element_series.#{d}").
        attr("x", 15).
        attr("y", 8)

      # vertical sector label
      @sectors.append("svg:text")
        .text((d) -> d.get 'key')
        .attr("class", "sector_label")
        .attr("x", - @height - 5)
        .attr("transform", "rotate(270)")
        .attr("text-anchor", "end")

      $('rect.carrier').qtip
        content: -> $(this).attr('title')
        show:
          event: 'mouseover' # silly IE
        hide:
          event: 'mouseout'  # silly IE
        position:
          my: 'bottom right'
          at: 'top center'

    refresh: =>
      total_value = @node_list.grand_total()
      @x = d3.scale.linear().domain([0, total_value]).range([0, @width])
      @y = d3.scale.linear().domain([0, total_value]).range([0, @height])

      @sector_offset = 0

      @svg.selectAll("g.sector").
        data(@sector_list.models, (d) -> d.get 'key' ).
        transition().duration(500).
        attr("transform", (d) =>
          old = @sector_offset
          @sector_offset += @x d.total_value()
          "translate(#{old})"
        )

      @label_offset = 0
      @svg.selectAll("text.sector_label").
        data(@sector_list.models, (d) -> d.get 'key' ).
        transition().duration(500).
        attr("dy", (d) => @x(d.total_value() / 2) + 5 ).
        text((d) -> "#{d.get 'key'} #{parseInt d.total_value()}PJ")

      # we need to track the offset for every sector
      offsets = {}
      for sector in D3.mekko.data.sectors
        offsets[sector] = 0

      @svg.selectAll(".carrier").
        data(@node_list.models, (d) -> d.key()).
        transition().duration(500).
        attr("width", (d) => @x d.sector.total_value() ).
        attr("height", (d) => d.val() / d.sector.total_value() * @height ).
        attr("y", (d) =>
          old = offsets[d.get 'sector']
          offsets[d.get 'sector'] += d.val() / d.sector.total_value() * @height
          old
        ).
        attr("title", (d) -> d.tooltip_text())

class D3.mekko.GroupCollection extends Backbone.Collection
  model: D3.mekko.NodeGroup

class D3.mekko.NodeList extends Backbone.Collection
  model: D3.mekko.Node
  grand_total: =>
    t = 0
    t += n.val() for n in @models
    t
