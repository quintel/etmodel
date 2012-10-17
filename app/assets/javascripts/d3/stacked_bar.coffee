D3.stacked_bar =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      @key = @model.get 'key'
      @initialize_defaults()

    can_be_shown_as_table: -> true

    outer_height: => @height + 10

    draw: =>
      margins =
        top: 20
        bottom: 20
        left: 30
        right: 40

      @width = 494 - (margins.left + margins.right)
      @series_height = 190
      @height = @series_height + (margins.top + margins.bottom) + (@model.series.models.length / 2 * 15)
      @svg = d3.select("#d3_container_#{@key}")
        .append("svg:svg")
        .attr("height", @height + margins.top + margins.bottom)
        .attr("width", @width + margins.left + margins.right)
        .append("svg:g")
        .attr("transform", "translate(#{margins.left}, #{margins.top})")

      # add legend
      # remove duplicate target series. Required for backwards compatibility.
      # When we'll drop the old charts we should use a single serie as target
      # rather than two
      target_lines = []
      series_for_legend = []
      for s in @model.series.models
        label = s.get 'label'
        if s.get 'is_target_line'
          if _.indexOf(target_lines, label) == -1
            target_lines.push label
            series_for_legend.push s
          # otherwise the target line has already been added
        else
          series_for_legend.push s

      legend_columns = if series_for_legend.length > 6 then 2 else 1
      @draw_legend
        svg: @svg
        series: series_for_legend
        width: @width
        vertical_offset: @series_height + 20
        columns: legend_columns

      # the stack method will filter the data and calculate the offset for every
      # item
      @stack_method = d3.layout.stack().offset('zero')
      stacked_data = _.flatten @stack_method(@prepare_data())

      @x = d3.scale.ordinal().rangeRoundBands([0, @width])
        .domain([App.settings.get('start_year'), App.settings.get('end_year')])

      # show years
      @svg.selectAll('text.year')
        .data([App.settings.get('start_year'), App.settings.get('end_year')])
        .enter().append('svg:text')
        .attr('class', 'year')
        .text((d) -> d)
        .attr('x', (d) => @x(d) + 10)
        .attr('y', @series_height + 10)
        .attr('dx', 45)

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 7])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 7])

      # there we go
      rect = @svg.selectAll('rect.serie')
        .data(stacked_data, (s) -> s.id)
        .enter().append('svg:rect')
        .attr('class', 'serie')
        .attr("width", @x.rangeBand() * 0.5)
        .attr('x', (s) => @x(s.x) + 10)
        .attr('y', @series_height)
        .style('fill', (d) => d.color)

      $('rect.serie').qtip
        content: -> $(this).attr('data-tooltip')
        show:
          event: 'mouseover' # silly IE
        hide:
          event: 'mouseout'  # silly IE
        position:
          my: 'bottom center'
          at: 'top center'
        style:
          classes: "ui-tooltip-bootstrap"

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(5)
        .tickSize(-420, 10, 0)
        .orient("right")
        .tickFormat((x) => Metric.autoscale_value x, @model.get('unit'))
      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@width - 25}, 0)")
        .call(@y_axis)

      # target lines
      # An ugly thing in the target lines is the extra attribute called "target
      # line position". If set to 1 then the target line must be shown on the
      # first column only, if 2 only on the 2nd. The CO2 chart is different, too
      @svg.selectAll('rect.target_line')
        .data(@model.target_series(), (d) -> d.get 'gquery_key')
        .enter()
        .append('svg:rect')
        .attr('class', 'target_line')
        .style('fill', (d) -> d.get 'color')
        .attr('height', 2)
        .attr('width', 136)
        .attr('x', (s) =>
          column = if s.get('target_line_position') == '1' # Brrrrr
            'start_year'
          else
            'end_year'
          @x(App.settings.get column) - 5)
        .attr('y', 0)

    refresh: =>
      # calculate tallest column
      tallest = Math.max(
        _.sum(@model.values_future()),
        _.sum(@model.values_present()),
        _.max(@model.values_targets()) || 0
      ) * 1.05
      # update the scales as needed
      @y = @y.domain([0, tallest]).nice()
      @inverted_y = @inverted_y.domain([0, tallest]).nice()

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      # let the stack method filter the data again, adding the offsets as needed
      stacked_data = _.flatten @stack_method(@prepare_data())
      @svg.selectAll('rect.serie')
        .data(stacked_data, (s) -> s.id)
        .transition()
        .attr('y', (d) => @series_height - @y(d.y0 + d.y))
        .attr('height', (d) => @y(d.y))
        .attr("data-tooltip", (d) =>
          html = d.label
          html += "<br/>"
          html += Metric.autoscale_value d.y, @model.get('unit')
        )

      # move the target lines
      @svg.selectAll('rect.target_line')
        .data(@model.target_series(), (d) -> d.get 'gquery_key')
        .transition()
        .attr 'y', (d) =>
          value = if d.get('target_line_position') is '1'
            d.safe_present_value()
          else
            d.safe_future_value()

          @series_height - @y(value)

      # draw grid

    # the stack layout method expects data to be in a precise format. We could
    # force the values() method but this way is simpler and cleaner.
    prepare_data: =>
      @model.non_target_series().map (s) ->
        [
          {
            x: App.settings.get('start_year')
            y: s.safe_present_value()
            id: "#{s.get 'gquery_key'}_present"
            color: s.get('color')
            label: s.get('label')
          },
          {
            x: App.settings.get('end_year')
            y: s.safe_future_value()
            id: "#{s.get 'gquery_key'}_future"
            color: s.get('color')
            label: s.get('label')
          }
        ]
