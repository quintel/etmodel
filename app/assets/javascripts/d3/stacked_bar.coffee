D3.stacked_bar =
  View: class extends D3ChartView
    el: 'body'
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @series = @model.series.models
      # the stack method will filter the data and calculate the offset
      # for every item
      @stack_method = (columns) ->
        _.flatten(columns.map (column) ->
          d3.layout.stack().offset('zero')(column.map (item) -> [item]))

    can_be_shown_as_table: -> true

    margins:
      top: 20
      bottom: 20
      left: 30
      right: 40

    is_empty: =>
      total = 0

      @prepare_data().map (d) ->
        total += (d.reduce (t,s) -> t.y + s.y)

      total <= 0

    draw: =>
      [@width, @height] = @available_size()

      # prepare legend
      # remove duplicate target series. Required for backwards compatibility.
      # When we'll drop the old charts we should use a single serie as target
      # rather than two
      target_lines = []
      series_for_legend = []
      for s in @series
        label = s.get 'label'
        if s.get 'is_target_line'
          if _.indexOf(target_lines, label) == -1
            target_lines.push label
            series_for_legend.push s
          # otherwise the target line has already been added
        else
          series_for_legend.push s

      legend_columns = if series_for_legend.length > 6 then 2 else 1
      legend_rows = series_for_legend.length / legend_columns
      legend_height = legend_rows * @legend_cell_height
      legend_margin = 20

      @series_height = @height - legend_height - legend_margin

      @svg = @create_svg_container @width, @series_height, @margins

      @draw_legend
        svg: @svg
        series: series_for_legend
        width: @width
        vertical_offset: @series_height + legend_margin
        columns: legend_columns

      columns = @get_columns()

      @x = d3.scale.ordinal().rangeRoundBands([0, @width])
        .domain(columns)

      @bar_width = @x.rangeBand() * 0.5

      # show years
      @svg.selectAll('text.year')
        .data(columns)
        .enter().append('svg:text')
        .attr('class', 'year')
        .text((d) -> d)
        .attr('x', (d) => @x(d))
        .attr('dx', @bar_width / 2)
        .attr('y', @series_height + 15)
        .attr('text-anchor', 'middle')

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 7])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 7])

      # there we go
      rect = @svg.selectAll('rect.serie')
        .data(@stack_method(@prepare_data()), (s) -> s.id)
        .enter().append('svg:rect')
        .attr('class', 'serie')
        .attr("width", @bar_width)
        .attr('x', (s) => @x(s.x) + 10)
        .attr('data-tooltip-title', (s) => s.label)
        .attr('y', @series_height)
        .style('fill', (d) => d.color)

      $("#{@container_selector()} rect.serie").qtip
        content:
          title: -> $(this).attr('data-tooltip-title')
          text:  -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom center'
          at: 'top center'

      # draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(5)
        .tickSize(-@width, 10, 0)
        .orient("right")
        .tickFormat(@main_formatter())
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
        .attr('width', @x.rangeBand() * .6)
        .attr('x', (s) =>
          column = if s.get('target_line_position') == '1' # Brrrrr
            'start_year'
          else
            'end_year'
          @x(App.settings.get column) - (@x.rangeBand() * .02))
        .attr('y', 0)

    refresh: =>
      # calculate tallest column
      tallest = (@model.max_series_value() || 0) * 1.05
      # update the scales as needed
      @y = @y.domain([0, tallest]).nice()
      @inverted_y = @inverted_y.domain([0, tallest]).nice()

      @y_axis.tickFormat(@main_formatter())

      # animate the y-axis
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      @svg.selectAll('rect.serie')
        .data(@stack_method(@prepare_data()), (s) -> s.id)
        .transition()
        .attr('y', (d) => @series_height - @y(d.y0 + d.y))
        .attr('height', (d) => @y(d.y))
        .attr("data-tooltip-text", (d) => @main_formatter()(d.y))

      # move the target lines
      @svg.selectAll('rect.target_line')
        .data(@model.target_series(), (d) -> d.get 'gquery_key')
        .transition()
        .attr 'y', (d) =>
          value = if d.get('target_line_position') is '1'
            if d.present_value() == null and d.safe_present_value() == 0 then 3*@series_height else d.safe_present_value()
          else
            if d.future_value() == null and d.safe_future_value() == 0 then 3*@series_height else d.safe_future_value()

          @series_height - @y(value)

      # draw grid

    get_columns: =>
      result = [@start_year, @end_year]
      if @model.year_1990_series().length
        result.unshift(1990)
      result

    # the stack layout method expects data to be in a precise format. We could
    # force the values() method but this way is simpler and cleaner.
    prepare_data: =>
      year_1990 = []
      @model.year_1990_series().forEach (s) ->
        year_1990.push(
          {
            x: 1990
            y: s.safe_present_value()
            id: "#{s.get 'gquery_key'}_1990"
            color: s.get('color')
            label: s.get('label')
          })

      present = []
      future = []
      @model.non_target_series().forEach (s) ->
        present.push(
          {
            x: App.settings.get('start_year')
            y: s.safe_present_value()
            id: "#{s.get 'gquery_key'}_present"
            color: s.get('color')
            label: s.get('label')
          })
        future.push(
          {
            x: App.settings.get('end_year')
            y: s.safe_future_value()
            id: "#{s.get 'gquery_key'}_future"
            color: s.get('color')
            label: s.get('label')
          })

      result = [present, future]
      if year_1990.length
        result.unshift(year_1990)
      result
