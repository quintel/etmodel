D3.targets =
  data:
    targets: [
      'co2_emissions',
      'net_energy_import',
      'net_electricity_import',
      'total_energy_cost',
      'electricity_cost',
      'renewable_percentage',
      'onshore_land',
      'onshore_coast',
      'offshore'
    ]

  # This represents a carrier within a sector
  Target: class extends Backbone.Model
    initialize: =>
      @namespace = D3.targets
      @success_query    = new ChartSerie({gquery_key: "policy_goal_#{@get 'key'}_reached"})
      @value_query      = new ChartSerie({gquery_key: "policy_goal_#{@get 'key'}_value"})
      @target_query     = new ChartSerie({gquery_key: "policy_goal_#{@get 'key'}_target_value"})
      @user_value_query = new ChartSerie({gquery_key: "policy_goal_#{@get 'key'}_user_value"})

      @namespace.series.push @success_query
      @namespace.series.push @value_query
      @namespace.series.push @target_query
      @namespace.series.push @user_value_query

      @scale = d3.scale.linear().domain([0,100])
      @axis = d3.svg.axis().scale(@scale).ticks(4).orient('bottom')

    max_value: =>
      max = 0
      for query in [@success_query, @value_query, @target_query, @user_value_query]
        max = x if (x = query.future_value()) > max
        max = x if (x = query.present_value()) > max
      max

    update_scale: => @scale = @scale.domain([0, @max_value()]).range([0, @namespace.width - 80])

    axis_builder: => @axis.scale(@scale)

    successful: => @success_query.future_value()

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @namespace = D3.targets
      @namespace.series = @model.series
      @targets = []
      for t in @namespace.data.targets
        @targets.push(new D3.targets.Target({key: t}))

      @initialize_defaults()

    draw: =>
      margins =
        top: 40
        bottom: 100
        left: 30
        right: 30

      @width = (@container_node().width()   || 490) - (margins.left + margins.right)
      @height = (@container_node().height() || 402) - (margins.top + margins.bottom)
      @namespace.width = @width
      t.scale.range([80, @width]) for t in @targets
      @svg = d3.select("#d3_container_targets").
        append("svg:svg").
        attr("height", @height + margins.top + margins.bottom).
        attr("width", @width + margins.left + margins.right).
        append("svg:g").
        attr("transform", "translate(#{margins.left}, #{margins.top})")

      @items = @svg.selectAll("g.target")
        .data(@targets, ((d) -> d.get 'key'))
        .enter()
        .append('svg:g')
        .attr('class', 'target')
        .attr('transform', (d, i) -> "translate(0, #{i * 40})")

      # labels first
      @items.append("svg:text")
        .text((d) -> I18n.t "targets.#{d.get 'key'}")
        .attr('class', 'target_label')
        .attr('text-anchor', 'end')
        .attr('x', 75)

      # now bars and axis
      @blocks = @items.append("svg:g")
        .attr("transform", "translate(80)")

      @current_values = @blocks.append("svg:rect")
        .attr('class', 'current_value')
        .attr('y', -10)
        .attr('height', 10)
        .attr('width', 0)
        .attr('fill', '#66ccff')

      @future_values = @blocks.append("svg:rect")
        .attr('class', 'future_value')
        .attr('y', 0)
        .attr('height', 10)
        .attr('width', 0)
        .attr('fill', '#0080ff')

      @user_targets = @blocks.append("svg:rect")
        .attr('class', 'target_value')
        .attr('y', -15)
        .attr('width', 2)
        .attr('height', 30)
        .attr('fill', '#ff0000')
        .style("opacity", 0.7)

      @axis = @blocks.append('svg:g')
        .attr("class", 'x_axis')
        .attr('transform', 'translate(0.5,10.5)')

    refresh: =>
      t.update_scale() for t in @targets

      targets = @svg.selectAll("g.target")
        .data(@targets, ((d) -> d.get 'key'))

      targets.selectAll('g.x_axis')
        .transition()
        .duration(500)
        .each((d) ->
          d3.select(this).call(d.axis_builder())
        )

      targets.selectAll('rect.current_value')
        .transition()
        .attr('width', (d) -> d.scale(d.value_query.present_value()) )

      targets.selectAll('rect.future_value')
        .transition()
        .attr('width', (d) -> d.scale(d.value_query.future_value()) )

      targets.selectAll('text.target_label')
        .transition()
        .style('stroke', (d) -> if d.successful() then '#00ff00' else '#000000')

      targets.selectAll('rect.target_value')
        .transition()
        .attr('x', (d) -> d.scale(d.target_query.future_value()) - 1)
        .attr('fill', (d) -> if d.successful() then '#008040' else '#ff0000')




