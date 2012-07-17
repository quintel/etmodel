D3.stacked_bar =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      @key = @model.get 'key'
      @initialize_defaults()

    draw: =>
      margins =
        top: 40
        bottom: 100
        left: 30
        right: 30

      @width = (@container_node().width()   || 490) - (margins.left + margins.right)
      @height = (@container_node().height() || 402) - (margins.top + margins.bottom)
      @svg = d3.select("#d3_container_#{@key}")
        .append("svg:svg")
        .attr("height", @height + margins.top + margins.bottom)
        .attr("width", @width + margins.left + margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{margins.left}, #{margins.top})")

    refresh: => true
