D3.target_bar =
  data:
    # The key must match the chart key
    renewability_targets: [
      {key: 'co2_emissions',          unit: 'MTon'},
      {key: 'renewable_percentage',   unit: '%', min: 0, max: 100}
    ],
    dependence_targets: [
      {key: 'net_energy_import',      unit: '%', min: 0, max: 100},
      {key: 'net_electricity_import', unit: '%', min: 0, max: 100}
    ],
    cost_targets: [
      {key: 'total_energy_costs',     unit: 'Bln euro'},
      {key: 'electricity_costs',      unit: 'Euro/MWh'}
    ],
    area_targets: [
      {key: 'onshore_land',           unit: 'km2'},
      {key: 'onshore_coast',          unit: 'km'},
      {key: 'offshore',               unit: 'km2'}
    ]

  # This represents a carrier within a sector
  Target: class extends Backbone.Model
    initialize: =>
      key = @get 'key'
      @namespace = D3.target_bar
      @success_query = new ChartSerie({gquery_key: "policy_goal_#{key}_reached"})
      @value_query   = new ChartSerie({gquery_key: "policy_goal_#{key}_value"})
      @target_query  = new ChartSerie({gquery_key: "policy_goal_#{key}_target_value"})
      @namespace.series.push @success_query, @value_query, @target_query
      @scale = d3.scale.linear()
      @axis = d3.svg.axis().tickSize(2, 0).ticks(4).orient('bottom')

    max_value: =>
      return m if m = @get('max')
      max = 0
      for query in [@success_query, @value_query, @target_query]
        max = x if (x = query.future_value()) > max
        max = x if (x = query.present_value()) > max
      # Let's add some padding
      max = 0 if max < 0
      max * 1.05

    min_value: => if (m = @get('min')) then m else 0

    update_scale: => @scale = @scale.domain([@min_value(), @max_value()]).range([0, @namespace.width - 80])

    axis_builder: => @axis.scale(@scale)

    successful: => @success_query.future_value()

    is_set: => _.isNumber @target_query.future_value()

    # negative values aren't allowed
    #
    format_value: (x) =>
      v = switch @get 'key'
        when 'net_electricity_import', 'renewable_percentage', 'net_energy_import'
          x * 100
        else x
      if v < 0 then v = 0
      v

    present_value: => @format_value @value_query.present_value()
    future_value: =>  @format_value @value_query.future_value()
    target_value: =>  @format_value @target_query.future_value()

  View: class extends D3ChartView
    el: "body"

    initialize: ->
      @key = @model.get 'key'
      @namespace = D3.target_bar
      @namespace.series = @model.series
      @targets = []
      @targets.push(new @namespace.Target(t)) for t in @namespace.data[@key]

      @initialize_defaults()

    outer_height: -> 250

    draw: =>
      margins =
        top: 25
        bottom: 10
        left: 35
        right: 18

      @width = @available_width() - (margins.left + margins.right)
      @height = @outer_height() - (margins.top + margins.bottom)
      @namespace.width = @width
      t.scale.range([80, @width]) for t in @targets
      @svg = @create_svg_container @width, @height, @margins

      # Every target belongs to a group which is translated altogether
      @items = @svg.selectAll("g.target")
        .data(@targets, ((d) -> d.get 'key'))
        .enter()
        .append('svg:g')
        .attr('class', 'target')
        .attr('transform', (d, i) -> "translate(0, #{i * 60})")

      # labels first
      @items.append("svg:text")
        .text((d) -> I18n.t "targets.#{d.get 'key'}")
        .attr('class', 'target_label')
        .attr('text-anchor', 'end')
        .attr('x', 75)
        .attr('y', 1)

      @items.append("svg:text")
        .text((d) -> d.get 'unit')
        .attr('class', 'target_unit')
        .attr('text-anchor', 'end')
        .attr('x', 75)
        .attr('y', 15)

      # now bars and axis
      @blocks = @items.append("svg:g")
        .attr("transform", "translate(80)")

      current_values = @blocks.append("svg:rect")
        .attr('class', 'current_value')
        .attr('y', -10)
        .attr('height', 15)
        .attr('width', 0)
        .attr('fill', '#66ccff')

      @blocks.append("svg:text")
        .text(App.settings.get("start_year"))
        .attr('class', 'year_label')
        .attr('y', 2)
        .attr('x', 2)

      future_values = @blocks.append("svg:rect")
        .attr('class', 'future_value')
        .attr('y', 6)
        .attr('height', 15)
        .attr('width', 0)
        .attr('fill', '#0080ff')

      @blocks.append("svg:text")
        .text(App.settings.get("end_year"))
        .attr('class', 'year_label')
        .attr('y', 17)
        .attr('x', 2)

      user_targets = @blocks.append("svg:rect")
        .attr('class', 'target_value')
        .attr('y', -15)
        .attr('width', 2)
        .attr('height', 38)
        .attr('fill', '#ff0000')
        .style("opacity", 0.7)

      @axis = @blocks.append('svg:g')
        .attr("class", 'x_axis')
        .attr('transform', 'translate(0.5, 22.5)')

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
        .attr('width', (d) -> d.scale(d.present_value()) )

      targets.selectAll('rect.future_value')
        .transition()
        .attr('width', (d) -> d.scale(d.future_value()) )

      targets.selectAll('text.target_label')
        .transition()
        .style('fill', (d) ->
          if !d.is_set()
            '#000000'
          else if d.successful()
            '#008040'
          else
            '#800040')
        .text((d) ->
          t = I18n.t "targets.#{d.get 'key'}"
          if !d.is_set()
            t
          else if d.successful()
            "#{t} +"
          else
            "#{t} -"
        )

      targets.selectAll('rect.target_value')
        .transition()
        .attr('x', (d) -> d.scale(d.target_value()) - 1)
        .attr('fill', (d) -> if d.successful() then '#008040' else '#ff0000')
        .style('opacity', (d) -> if d.is_set() then 0.7 else 0.0)



