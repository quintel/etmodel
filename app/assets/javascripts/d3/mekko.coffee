D3.mekko =
  # This represents a carrier within a sector
  Node: class extends Backbone.Model
    initialize: =>
      @sector = D3.mekko.sector_list.find((s) => s.get('key') == @get('sector'))
      @carrier = D3.mekko.carrier_list.find((s) => s.get('key') == @get('carrier'))
      @sector.nodes.push this
      @carrier.nodes.push this

    val:   => @get('gquery').future_value()
    label: => @get('label') || @get('gquery')
    key:   => "#{@get 'carrier'}_#{@get 'sector'}"
    tooltip_text: =>
      "#{@get 'carrier'} #{@get 'sector'}<br/>#{parseInt @val()} PJ"

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

    # lots of ugly transformations to adapt the current conventions
    prepare_data: =>
      sectors  = []
      carriers = []
      for s in @model.series.models
        sectors.push s.get('group_translated')
        carriers.push
          label: s.get('label')
          color: s.get('color')
      sectors  = _.uniq sectors
      carriers = _.uniq(carriers, false, (c) -> c.label)

      for sector in sectors
        @sector_list.add
          key: sector
      for carrier in carriers
        @carrier_list.add
          key: carrier.label
          color: carrier.color

      for s in @model.series.models
        sector  = s.get('group_translated')
        carrier = s.get('label')
        @node_list.add
          sector: sector
          carrier: carrier
          gquery: s.get('gquery')
          color: s.get('color')

    draw: =>
      @prepare_data()
      margins =
        top: 10
        bottom: 100
        left: 30
        right: 10

      @width = (@container_node().width()   || 490) - (margins.left + margins.right)
      @height = (@container_node().height() || 402) - (margins.top + margins.bottom)
      @svg = d3.select("#d3_container_#{@model.get 'key'}").
        append("svg:svg").
        attr("height", @height + margins.top + margins.bottom).
        attr("width", @width + margins.left + margins.right).
        append("svg:g").
        attr("transform", "translate(#{margins.left}, #{margins.top})")

      y_scale = d3.scale.linear().domain([100,0]).range([0, @height])
      @y_axis = d3.svg.axis().scale(y_scale).ticks(4).orient("left")
        .tickFormat((x) -> "#{x}%")
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
        style("fill", (d) -> d.get 'color').
        attr("y", 10).
        attr("x", 0).
        attr("data-rel", (d) -> d.key())

      # vertical sector label
      @sectors.append("svg:text")
        .text((d) -> d.get 'key')
        .attr("class", "sector_label")
        .attr("x", - @height - 5)
        .attr("transform", "rotate(270)")
        .attr("text-anchor", "end")

      $('rect.carrier').qtip
        content: -> $(this).attr('data-tooltip')
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
        text((d) -> "#{d.get 'key'} #{parseInt d.total_value()} PJ")

      # we need to track the offset for every sector
      offsets = {}
      for sector in @sector_list.pluck('key')
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
        attr("data-tooltip", (d) -> d.tooltip_text())

class D3.mekko.GroupCollection extends Backbone.Collection
  model: D3.mekko.NodeGroup

class D3.mekko.NodeList extends Backbone.Collection
  model: D3.mekko.Node
  grand_total: =>
    t = 0
    t += n.val() for n in @models
    t
