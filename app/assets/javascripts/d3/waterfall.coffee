D3.waterfall =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      @key = @model.get 'key'
      @initialize_defaults()
      @series = @model.series.models

    can_be_shown_as_table: -> true

    outer_height: -> 400

    draw: =>
      margins =
        top: 20
        bottom: 80
        left: 20
        right: 40

      @width = @$el.width() - (margins.left + margins.right)
      @height = 360 - (margins.top + margins.bottom)
      # height of the series section
      @series_height = 190
      @column_width = (@width - 15) / (@series.length + 1) * 0.8
      @svg = d3.select("#d3_container_#{@key}")
        .append("svg:svg")
        .attr("height", @height + margins.top + margins.bottom)
        .attr("width", @width + margins.left + margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{margins.left}, #{margins.top})")

      @x = d3.scale.ordinal().rangeRoundBands([0, @width - 15])
        .domain(@labels())

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 1])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 1])

      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(4)
        .tickSize(-429, 10, 0)
        .orient("right")
        .tickFormat((x) => Metric.autoscale_value x, @model.get('unit'))

      @x_axis = d3.svg.axis()
        .scale(@x)
        .ticks(4)
        .tickSize(2, 2, 0)
        .orient("bottom")

      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@width - 15}, 0)")
        .call(@y_axis)

      @svg.append("svg:g")
        .attr("class", "x_axis inner_grid")
        .attr("transform", "translate(0, #{@series_height})")
        .call(@x_axis)

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

      $('rect.serie').qtip
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
      max_value = d3.max(data, (d) -> d.offset)
      @y = @y.domain([0, max_value])
      @inverted_y = @inverted_y.domain([0, max_value])

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      @svg.selectAll('rect.serie')
        .data(data, (d) -> d.key)
        .transition()
        .attr('y', (d) => @inverted_y d.offset)
        .attr('height', (d) => @y d.value)
        .attr('data-tooltip-text', (d) => Metric.autoscale_value d.value, @model.get('unit'))

    # The final label is not defined in the chart attributes, so we must add
    # add it manually. This is ugly!
    labels: =>
      return @_labels if @_labels
      labels = _.map @series, (s) -> s.get('label')
      labels.push @last_column()
      @_labels = labels

    last_column: =>
      if @model.get('id') == 51 then App.settings.get("end_year") else 'Total'

    prepare_data: =>
      out = []
      offset = 0
      for s in @series
        # serious ugliness here
        #
        g = s.get('group')
        val = if g == 'future'
          s.safe_future_value()
        else if g == 'value' # ?! TODO: rename!
          s.safe_present_value()
        else
          s.safe_future_value() - s.safe_present_value()

        new_offset = if val >= 0
          offset + val
        else
          offset

        out.push
          key: s.get 'label'
          value: Math.abs val
          offset: new_offset
          color: s.get 'color'

        offset = offset + val
      # The last item is calculated using the other columns
      out.push
        key: @last_column()
        color: out[0].color
        value: offset
        offset: offset
      out
