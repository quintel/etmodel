D3.treemap =
  data:
    sectors: ['industry', 'households', 'buildings', 'transport', 'agriculture', 'other']
    carriers: ['biomass', 'oil', 'gas', 'coal', 'waste', 'biofuels', 'electricity', 'hot_water']

  Node: class extends Backbone.Model
    initialize: ->
      @gquery = new ChartSerie
        gquery_key: @get('gquery')
      D3.treemap.series.push @gquery

    # value is apparently a reserved name
    val: => @gquery.future_value()

    label: => "#{@get('sector')} #{@get('carrier')}"

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @initialize_defaults()
      @color = d3.scale.category20c()
      D3.treemap.series = @model.series
      @prepare_data()

    # D3 layouts expect data in a precise format
    prepare_data: =>
      return @out if @out
      out =
        name: "treemap"
        children: []
      for carrier in D3.treemap.data.carriers
        group =
          name: carrier
          children: []
        for sector in D3.treemap.data.sectors
          item = new D3.treemap.Node
            gquery: "#{carrier}_#{sector}_in_mekko_of_final_demand"
            sector: sector
            carrier: carrier
          group.children.push item
        out.children.push group
      @out = out

    draw: =>
      @width = @container_node().width()   || 490
      @height = @container_node().height() || 502
      @treemap = d3.layout.treemap()
        .size([@width, @height])
        .sticky(true)
        .value((d) -> d.val())
      @svg = d3.select("#d3_container_treemap").
        append("div").
        style("position", "relative").
        style("height", "#{@height}px").
        style("width", "#{@width}px")
      @svg.data([@prepare_data()]).selectAll("div").
        data(@treemap.nodes).
        enter().
        append("div").
        attr("class", "cell").
        attr("data-label", (d) -> d.label() unless d.children).
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

        $("div.cell").qtip
          content:
            text: -> $(this).attr('data-label')
          position:
            my: 'top right'
            at: 'bottom right'

    refresh: =>
      @svg.selectAll("div").
        data(@treemap.value( (d) ->
          d.val()
        )).
        attr("data-label", (d) ->
          # used by tipsy
          return if d.children
          val = d.val().toFixed(2)
          "#{d.label()}: #{val}PJ"
          ).
        transition().
        duration(500).
        call(@cell)

    cell: ->
      @style 'left', (d) -> "#{d.x}px"
      @style 'top', (d) -> "#{d.y}px"
      @style 'width', (d) -> Math.max(0, d.dx - 1) + "px"
      @style 'height', (d) -> Math.max(0, d.dy - 1) + "px"



