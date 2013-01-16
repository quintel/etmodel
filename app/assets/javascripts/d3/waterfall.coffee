D3.waterfall =
  View: class extends D3ChartView
    initialize: ->
      @key = @model.get 'key'
      @initialize_defaults()
      @series = @model.series.models

    can_be_shown_as_table: -> true

    margins:
      top: 20
      bottom: 20
      left: 20
      right: 40

    draw: =>
      @width  = @available_width()  - (@margins.left + @margins.right)
      @height = @available_height() - (@margins.top + @margins.bottom)

      labels_height = 90
      labels_margin = 15
      @series_height = @height - labels_height - labels_margin
      @series_width = @width - 15

      @column_width = @series_width / (@series.length + 1) * 0.6
      @svg = d3.select(@container_selector())
        .append("svg:svg")
        .attr("height", @height + @margins.top + @margins.bottom)
        .attr("width", @width + @margins.left + @margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{@margins.left}, #{@margins.top})")

      @y = d3.scale.linear().range([@series_height, 0]).domain([-10, 10])

      @y_axis = d3.svg.axis()
        .scale(@y)
        .ticks(4)
        .tickSize(-@series_width, 10, 0)
        .orient("right")
        .tickFormat((x) => Metric.autoscale_value x, @model.get('unit'))

      @x = d3.scale.ordinal().rangeRoundBands([0, @series_width])
        .domain(@labels())

      @x_axis = d3.svg.axis()
        .scale(@x)
        .tickSize(0, 0, 0)
        .orient("bottom")

      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@series_width}, 0)")
        .call(@y_axis)

      @svg.append("svg:g")
        .attr("class", "x_axis inner_grid")
        .attr("transform", "translate(0, #{@series_height})")
        .call(@x_axis)

      # let's rotate the labels
      offset = @column_width / 2
      @svg.selectAll('.x_axis text')
        .attr('text-anchor', 'end')
        .attr('transform', "rotate(-90) translate(#{-labels_margin}, #{-offset})")

      @svg.selectAll('rect.serie')
        .data(@prepare_data(), (d) -> d.key)
        .enter()
        .append('rect')
        .attr('class', 'serie')
        .style('fill', (d) -> d.color)
        .attr('width', @column_width)
        .attr('height', 10)
        .attr('y', 50)
        .attr('x', (d) => @x d.key)
        .attr('data-tooltip-title', (d) -> d.key)

      @svg.selectAll('text.serie')
        .data(@prepare_data(), (d) -> d.key)
        .enter()
        .append('text')
        .attr('class', 'serie')
        .attr('y', 0)
        .attr('x', (d) => @x(d.key) + @column_width / 2)
        .attr("text-anchor", "middle")

      $("#{@container_selector()} rect.serie").qtip
        content:
          title: -> $(this).attr('data-tooltip-title')
          text: -> $(this).attr('data-tooltip-text')
        position:
          my: 'bottom center'
          at: 'top center'
          follow: 'mouse'

    refresh: =>
      data = @prepare_data()
      # update the scales as needed
      max_value = d3.max(data, (d) -> d.top) * 1.2
      min_value = d3.min(data, (d) -> d.bottom) * 1.1
      min_value = 0 if min_value > 0

      @y.domain([min_value, max_value])

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@y))

      @svg.selectAll('rect.serie')
        .data(data, (d) -> d.key)
        .transition()
        .attr('y', (d) => @y d.top)
        .attr('height', (d) => @y(d.bottom) - @y(d.top))
        .attr('data-tooltip-text', (d) => Metric.autoscale_value d.value, @model.get('unit'))

      @svg.selectAll('text.serie')
        .data(data, (d) -> d.key)
        .transition()
        .attr('y', (d) =>
          if d.value >= 0
            @y(d.top) - 5
          else
            @y(d.bottom) + 10
        )
        .text((d) => Metric.autoscale_value d.value, @model.get('unit'))

    # The final label is not defined in the chart attributes, so we must add
    # add it manually. This is ugly!
    labels: =>
      return @_labels if @_labels
      labels = _.map @series, (s) -> s.get('label')
      labels.push @last_column()
      @_labels = labels

    last_column: =>
      if @model.get('key') == 'future_energy_imports'
        App.settings.get("end_year")
      else
       'Total'

    prepare_data: =>
      out = []
      previous_top = 0

      for s in @series
        # The group attributes set which value we're looking for:
        # present / future / (future-present)
        # (future-present) is the default
        g = s.get('group')
        value = if g == 'future'
          s.safe_future_value()
        else if g == 'present'
          s.safe_present_value()
        else
          s.safe_future_value() - s.safe_present_value()

        if value >= 0
          bottom = previous_top
          top = previous_top + value
        else
          top = previous_top
          bottom = top + value

        out.push
          key: s.get 'label'
          value: value
          top: top
          bottom: bottom
          color: s.get 'color'

        previous_top = if value < 0 then bottom else top
        previous_bottom = bottom

      # The last item is calculated using the other columns
      out.push
        key: @last_column()
        color: out[0].color
        top: if previous_top > 0 then previous_top else 0
        bottom: if previous_top > 0 then 0 else previous_top
        value: if previous_top >= 0 then previous_top else previous_bottom
      out
