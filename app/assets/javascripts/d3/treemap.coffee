D3.treemap =
  data:
    sectors: ['industry', 'households', 'buildings', 'transport', 'agriculture', 'other']
    carriers: ['biomass', 'oil', 'gas', 'coal', 'waste', 'bio_fuels', 'electricity', 'hot_water']

  Node: class extends Backbone.Model
    initialize: ->
      @gquery = new ChartSerie
        gquery_key: @get('gquery')
      D3.treemap.series.push @gquery

    # value is apparently a reserved name
    val: => @gquery.safe_future_value()

    label: => "#{@get('sector')} #{@get('carrier')}"

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @initialize_defaults()
      @color = d3.scale.category20c()
      D3.treemap.series = @model.series
      @prepare_data()

    outer_height: => @height + 20

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
      @width = @available_width()
      @height = 350
      @treemap = d3.layout.treemap()
        .size([@width, @height])
        .sticky(true)
        .value((d) -> d.val())
      @svg = d3.select(@container_selector()).
        append("div").
        style("position", "relative").
        style("height", "#{@height}px").
        style("width", "#{@width}px")
      @svg.data([@prepare_data()]).selectAll("div").
        data(@treemap.nodes).
        enter().
        append("div").
        attr("class", "cell").
        filter((d) -> !d.children).
        attr("data-label", (d) -> d.label()).
        style("background", (d, i) => d.get('color') || @color(i)).
        text((d) -> d.label()).call(@cell)

        $("#{@container_selector()} div.cell").qtip
          content:
            text: -> $(this).attr('data-label')
          position:
            my: 'bottom center'
            at: 'top center'

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



