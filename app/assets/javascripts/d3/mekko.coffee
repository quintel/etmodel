D3.mekko =
  # This represents a carrier within a sector
  Node: class extends Backbone.Model
    initialize: =>
      @view = @get 'view'
      @sector  = @view.sector_list.find((s) => s.get('key') == @get('sector'))
      @carrier = @view.carrier_list.find((s) => s.get('key') == @get('carrier'))
      @sector.nodes.push this
      @carrier.nodes.push this

    val:   => @get('gquery').safe_future_value()
    label: => @get('label') || @get('gquery')
    key:   => "#{@get 'carrier'}_#{@get 'sector'}"

  NodeGroup: class extends Backbone.Model
      initialize: -> @nodes = []
      total_value: => d3.sum @nodes, (n) -> n.val()

  View: class extends D3ChartView
    initialize: ->
      @series = @model.series.models
      @initialize_defaults()

    can_be_shown_as_table: -> true

    outer_height: -> 410
    # lots of ugly transformations to adapt the current conventions
    prepare_data: =>
      @sector_list  = new D3.mekko.GroupCollection()
      @carrier_list = new D3.mekko.GroupCollection()
      @node_list    = new D3.mekko.NodeList()

      sectors  = []
      carriers = []
      for s in @series
        sectors.push s.get('group_translated')
        carriers.push
          label: s.get('label')
          color: s.get('color')
          view: this
      sectors  = _.uniq sectors
      carriers = _.uniq(carriers, false, (c) -> c.label)

      for sector in sectors
        @sector_list.add
          key: sector
          view: this
      for carrier in carriers
        @carrier_list.add
          key: carrier.label
          label: carrier.label # used by the legend
          color: carrier.color
          view: this

      for s in @series
        sector  = s.get('group_translated')
        carrier = s.get('label')
        @node_list.add
          sector: sector
          carrier: carrier
          gquery: s.get('gquery')
          color: s.get('color')
          view: this

    draw: =>
      @prepare_data()
      margins =
        top: 10
        bottom: 100
        left: 35
        right: 10

      @width = @available_width() - (margins.left + margins.right)
      @height = @outer_height() - (margins.top + margins.bottom)
      @series_height = 190 # the rest of the height will be taken by the legend
      @svg = d3.select(@container_selector())
        .append("svg:svg")
        .attr("height", @height + margins.top + margins.bottom)
        .attr("width", @width + margins.left + margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{margins.left}, #{margins.top})")

      @x = d3.scale.linear().range([0, @width])
      @y = d3.scale.linear().range([0, @series_height])

      y_scale = d3.scale.linear().domain([100,0]).range([0, @series_height])

      # axis
      @y_axis = d3.svg.axis().scale(y_scale).ticks(4).orient("left")
        .tickFormat((x) -> "#{x}%")
      @svg.append("svg:g")
        .attr("transform", "translate(0, 0.5)") # for nice, crisp lines
        .attr("class", "y_axis").call(@y_axis)

      # Every sector is assigned a group element
      @sectors = @svg.selectAll("g.sector")
        .data(@sector_list.models, (d) -> d.get 'key' )
        .enter().append("svg:g")
        .attr("class", "sector")
        .attr("transform", "translate(30)")
        .attr("data-rel", (d) -> d.get 'key')

      # Create items inside the group
      @sectors.selectAll(".carrier")
        .data( ((d) -> d.nodes) , ((d) -> d.key()) )
        .enter().append("svg:rect")
        .attr("class", "carrier")
        .attr("height", 10)
        .attr("width", 10)
        .style("fill", (d) -> d.get 'color')
        .attr("y", 10)
        .attr("x", 0)
        .attr("data-rel", (d) -> d.key())
        .attr('data-tooltip-title', (n) -> "#{n.get 'carrier'} #{n.get 'sector'}")

      # vertical sector label
      @sectors
        .append("svg:text")
        .attr('class', 'sector_label')
        .text((d) -> d.get 'key')
        .attr("transform", "rotate(90)")
        .attr("text-anchor", "start")
        .attr('x', 200)

      @draw_legend
        svg: @svg
        series: @carrier_list.models
        width: @width
        vertical_offset: @series_height + 130
        columns: if @carrier_list.length > 9 then 3 else 2

      $("#{@container_selector()} rect.carrier").qtip
        content:
          title: -> $(this).attr('data-tooltip-title')
          text: -> $(this).attr('data-tooltip-text')
        position:
          my: 'bottom right'
          at: 'top center'
          follow: 'mouse'

    refresh: =>
      total_value = @node_list.grand_total()
      @x.domain([0, total_value])
      @y.domain([0, total_value])

      @sector_offset = 0

      @svg.selectAll("g.sector")
        .data(@sector_list.models, (d) -> d.get 'key' )
        .transition().duration(500)
        .attr("transform", (d) =>
          old = @sector_offset
          @sector_offset += @x d.total_value()
          "translate(#{old})"
        )

      @label_offset = 0
      @svg.selectAll("text.sector_label")
        .data(@sector_list.models, (d) -> d.get 'key' )
        .transition().duration(500)
        .attr("dy", (d) => -@x(d.total_value() / 2))
        .text((d) -> "#{d.get 'key'} #{parseInt d.total_value()} PJ")

      # we need to track the offset for every sector
      offsets = {}
      for sector in @sector_list.pluck('key')
        offsets[sector] = 0

      @svg.selectAll(".carrier")
        .data(@node_list.models, (d) -> d.key())
        .transition().duration(500)
        .attr("width", (d) => @x d.sector.total_value() )
        .attr("height", (d) =>
          x = d.val() / d.sector.total_value() * @series_height
          if _.isNaN(x) then 0 else x
        )
        .attr("y", (d) =>
          old = offsets[d.get 'sector']
          x = d.val() / d.sector.total_value() * @series_height
          if _.isNaN(x) then x = 0
          offsets[d.get 'sector'] += x
          old
        )
        .attr("data-tooltip-text", (d) -> Metric.autoscale_value d.val(), 'PJ')

class D3.mekko.GroupCollection extends Backbone.Collection
  model: D3.mekko.NodeGroup

class D3.mekko.NodeList extends Backbone.Collection
  model: D3.mekko.Node
  grand_total: => d3.sum @models, (n) -> n.val()
