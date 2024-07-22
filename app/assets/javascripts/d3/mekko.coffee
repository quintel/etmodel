D3.mekko =
  # This represents a carrier within a sector, ie a chart rectangle
  #
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

  View: class extends D3ChartView
    initialize: ->
      @series = @model.series.models
      @initialize_defaults()

    tableOptions:
      labelFormatter: -> (s) ->
        group = I18n.t("output_element_series.groups.#{ s.get('group') }")

        "#{ s.get('label') } - #{ group }"

    can_be_shown_as_table: -> true

    # To render the mekko we need three collections:
    # - sectors  (~= the column, if you want to see it this way)
    # - carriers (used for legend only)
    # - nodes    (all the rectangles of the chart)
    # This methods builds them using the chart series.
    #
    prepare_data: =>
      @sector_list  = new D3.mekko.GroupCollection()
      @carrier_list = new D3.mekko.GroupCollection()
      @node_list    = new D3.mekko.NodeList()

      # Intermediate objects we use later to build the Backbone collections
      #
      sectors  = []
      carriers = []
      for s in @series
        sectors.push s.get('group_translated')
        carriers.push
          label: s.get('label')
          color: s.get('color')
          view: this

      # Build sector and carrier collections
      #
      sectors = _.uniq sectors
      for sector in sectors
        @sector_list.add
          key: sector
          view: this

      carriers = _.uniq(carriers, false, (c) -> c.label)
      for carrier in carriers
        @carrier_list.add
          key: carrier.label
          label: carrier.label # used by the legend
          color: carrier.color
          view: this

      # Add all nodes to the global collection
      #
      for s in @series
        @node_list.add
          sector: s.get('group_translated')
          carrier: s.get('label')
          gquery: s.get('gquery')
          color: s.get('color')
          view: this

    margins:
      top: 10
      bottom: 26
      left: 35
      right: 10

    col_value_scaler: =>
      max_y_value = _.max(@sector_list.map((a) -> a.total_value()))
      Quantity.scaleAndFormatBy(max_y_value, @model.get('unit'))

    is_empty: =>
      _.sum(@model.values_future()) <= 0

    draw: =>
      @prepare_data()
      [@width, @height] = @available_size()

      @label_height = 85 # rotated labels
      @label_margin = 25

      @display_legend()

      @series_height  = @height - @label_margin
      @label_offset   = @series_height + @label_margin

      @svg = @create_svg_container @width, @series_height + @label_height, @margins

      @x = d3.scale.linear().range([0, @width])
      @y = d3.scale.linear().range([0, @series_height])

      y_scale = d3.scale.linear().domain([100,0]).range([0, @series_height])

      # axis
      @y_axis = d3.svg.axis().scale(y_scale).ticks(4).orient("left")
        .tickFormat((x) -> "#{x}%")
      @svg.append("svg:g")
        .attr("transform", "translate(0, 0.5)") # for nice, crisp lines
        .attr("class", "y_axis").call(@y_axis)

      # Every sector is assigned a group element (~= a column)
      #
      @sectors = @svg.selectAll("g.sector")
        .data(@sector_list.models, (d) -> d.get 'key' )
        .enter().append("svg:g")
        .attr("class", "sector")
        .attr("transform", "translate(30)")
        .attr("data-rel", (d) -> d.get 'key')

      # Then inside every column we create the carrier items
      #
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

      # Let's append a vertical sector label
      #
      sector_group = @sectors
        .append('g')
        .attr('class', 'sector_label')
        .attr('transform', "translate(0, #{@label_offset})")

      @svg.selectAll(".sector_line")
        .data(@sector_list.models, (d) -> d.get 'key' )
        .enter().append("svg:line")
        .attr('class', 'sector_line')
        .attr("stroke-width", "1px")
        .attr("fill", "none")
        .attr("stroke", "#000000")
        .attr("x1", 0)
        .attr("x2", 0)
        .attr("y1", @label_offset - 25)
        .attr("y2", @label_offset - 2)

      sector_label = sector_group.append("svg:text")
        .attr("text-anchor", "end")
        .attr("transform", "rotate(-90) translate(0, -5)")

      sector_label.append("svg:tspan")
        .attr('class', 'key')
        .attr("dy", 0)
        .attr('x', 0)

      sector_label.append("svg:tspan")
        .attr('class', 'total_value')
        .attr("dy", 10)
        .attr('x', 0)
        .style("font-size", "75%")

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

      # Let's first move the entire columns, building the offset up. Since
      # they're actually groups, the column content will be moved as well.
      #
      @svg.selectAll("g.sector")
        .data(@sector_list.models, (d) -> d.get 'key' )
        # .transition().duration(500)
        .attr("transform", (d) =>
          old = @sector_offset
          @sector_offset += @x d.total_value()
          "translate(#{old})"
        )

      # Move and update the vertical label
      #
      average_width = @x(total_value / @sector_list.models.length)

      sector_label = @svg.selectAll("g.sector_label")
        .data(@sector_list.models, (d) -> d.get 'key' )
        # .transition().duration(500)
        .attr('transform', (d) => "translate(#{@x(d.total_value() / 2)}, #{@label_offset})")
        .select('text')

      # Value formatting removes any HTML elements (such as <sup/> which will
      # not display correctly).
      sector_label.select('text tspan.total_value').html (d) =>
        @col_value_scaler()(d.total_value()).replace(/<[^>]+?>/g, '')

      sector_label.select('text tspan.key')
        .text((d) -> d.get 'key')

      # let's track the vertical offset for every sector
      offsets = {}
      offsets[sector] = 0 for sector in @sector_list.pluck('key')

      # Update the rectangles
      #
      @svg.selectAll(".carrier")
        .data(@node_list.models, (d) -> d.key())
        # .transition().duration(500)
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
        .attr("data-tooltip-text", (d) => @main_formatter()(d.val()))

      @display_legend()

      @wrapLabels()
      @fitHeightToLabels()
      @arrangeLabels()
      @moveArrows()

    display_legend: =>
      $(@container_selector()).find('.legend').remove()

      @draw_legend
        series: @prepare_legend_items()
        width: @width
        vertical_offset: @series_height + @label_height
        columns: 2

    prepare_legend_items: =>
      _.filter(@carrier_list.models, (s) -> Math.abs(s.total_value()) > 1e-7).reverse()

    wrapLabels: =>
      label_height = @label_height

      @svg.selectAll("tspan.key").each((d) ->
        el         = d3.select(this)
        words      = el.text().split(/\s+/).reverse()
        line       = []
        lineNumber = 0
        lineHeight = 1.1
        y          = el.attr('y')

        el.text(null)
          .attr("x", 0)
          .attr("y", y)
          .attr("dy", "0em")

        while word = words.pop()
          line.push(word)
          el.text(line.join(' '))

          if el.node().getComputedTextLength() > label_height
            line.pop()
            el.text(line.join(' '))
            line = [word]
            el   = el.insert("tspan", "tspan + *")
                     .attr("x", 0)
                     .attr("y", y)
                     .attr("dy", ++lineNumber * lineHeight + "em")
                     .text(word)
      )

    # Increase the height of the SVG element to fit the largest unwrapped label.
    fitHeightToLabels: ->
      # @svg is actually the <g> element...
      real_svg   = @svg.node().parentNode
      svg_height = Math.max(real_svg.getBoundingClientRect().height, @series_height + @label_height)

      g_height   = @svg.node().getBoundingClientRect().height

      # Need to adjust the height for the transform of the <g> element. Only the
      # transform from the top of the element matters.
      transform  = d3.transform(@svg.attr('transform')).translate[1] / 2

      if g_height > (svg_height - transform)
        real_svg.setAttribute('height', g_height + transform)

    # Arranges the labels for each sector so that no labels overlap.
    #
    # Tests the position of each label against every other label and moves any
    # which overlap until there are no more overlaps.
    arrangeLabels: =>
      # Defines the left- and right-most edges of the chart. Labels will not be
      # permitted outside these limits
      maxLeft  = @svg[0][0].getBoundingClientRect().left + 20 # + 20 for axis.
      maxRight = @svg[0][0].getBoundingClientRect().right

      # Assumes that selectAll returns labels in the order they appear in the
      # DOM (i.e. left-to-right).
      labels = @svg.selectAll('g.sector_label')[0]

      # Iterates through label 1..n, providing the position of the label and the
      # previous label to a "value" function which may return by how much to
      # move the label in order to resolve a collision with the previous.
      moveLabels = (labels, value) ->
        labels.reduce (prevLabel, label) ->
          prevRect = prevLabel.getBoundingClientRect()
          rect     = label.getBoundingClientRect()
          moveBy   = value(prevRect, rect)

          if moveBy
            el = d3.transform(d3.select(label).attr('transform'))
            el.translate = [el.translate[0] + moveBy, el.translate[1]]

            # Prevent moving the label beyond the right- or left-most edges of
            # the chart.
            if (rect.right + moveBy) > maxRight
              el.translate[0] -= ((rect.right + moveBy) - maxRight)
            else if (rect.left + moveBy) < maxLeft
              el.translate[0] += (maxLeft - (rect.left + moveBy))

            d3.select(label)
              .attr('transform', 'translate('+ el.translate + ')')

          # The current label becomes prevLabel in the next iteration.
          return label

      # Arrange labels left-to-right.
      moveLabels labels, (previous, current) ->
        previous.right - current.left if previous.right > current.left

      # Arrange labels right-to-left (to fix any smushed up against the right
      # side of the chart).
      moveLabels labels.reverse(), (previous, current) ->
        previous.left - current.right if previous.left < current.right

    moveArrows: =>
      x = @x
      sector_offset = 0
      sector_labels = @svg.selectAll('g.sector_label')

      @svg.selectAll('line.sector_line').each (d, i) ->
        width   = x(d.total_value())
        label_x = d3.transform(d3.select(sector_labels[0][i])
          .attr('transform'))
          .translate[0]

        x2 = sector_offset + label_x

        sector_offset += width

        d3.select(this)
          .attr('x1', sector_offset - (width / 2))
          .attr('x2', x2)

# Pseudo-collection of nodes
#
class D3.mekko.NodeGroup extends Backbone.Model
  initialize: -> @nodes = []
  total_value: => d3.sum @nodes, (n) -> n.val()

# Collection of NodeGroups
#
class D3.mekko.GroupCollection extends Backbone.Collection
  model: D3.mekko.NodeGroup

# This collection holds all the nodes
#
class D3.mekko.NodeList extends Backbone.Collection
  model: D3.mekko.Node
  grand_total: => d3.sum @models, (n) -> n.val()
