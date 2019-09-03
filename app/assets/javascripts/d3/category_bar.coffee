categoriesFromSeries = (series) ->
  byGroup = (serie) -> serie.get('group')

  # Series are already sorted; the order of each category is determined based
  # on the position of the series.
  orderedCategoryNames = _.uniq(series.map(byGroup))

  grouped = _.groupBy(series, byGroup)

  # Remove any groups which don't contain at least one value series.
  for key, series of grouped
    if !_.some(series, (serie) -> !serie.get('is_target_line'))
      orderedCategoryNames = _.without(orderedCategoryNames, key)

  for groupName in orderedCategoryNames
    new D3.category_bar.Category(groupName, grouped[groupName])

D3.category_bar =
  # Contains information about, and series for, a category.
  Category: class Category
    constructor: (@key, @series) ->
      @targetSeries = @series.filter((serie) -> serie.get('is_target_line'))
      @valueSeries = @series.filter((serie) -> !serie.get('is_target_line'))

    # The category max is the highest target series, or the sum of all
    # non-target series.
    maxValue: () ->
      sumPresent = d3.sum(
        @valueSeries.map((serie) -> serie.safe_present_value())
      )

      sumFuture = d3.sum(
        @valueSeries.map((serie) -> serie.safe_future_value())
      )

      d3.max(_.flatten([
        @targetSeries.map((serie) -> serie.safe_future_value()),
        @targetSeries.map((serie) -> serie.safe_present_value()),
        sumPresent,
        sumFuture
      ]))

    # Columns which will be rendered on the chart to show the category data.
    columns: () ->
      [
        { key: "#{@key}_present", name: '', period: 'present' },
        { key: "#{@key}_future", name: @key, period: 'future' }
      ]

  # The category bar view.
  View: class extends D3ChartView
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
      bottom: 40
      left: 30
      right: 40

    legend_margin: 20

    is_empty: =>
      total = 0

      @prepare_data().map (d) ->
        total += (d.reduce (t,s) -> t.y + s.y)

      total <= 0

    draw: =>
      @categories = categoriesFromSeries(@series)

      [@width, @height] = @available_size()

      @series_height = @height - @legend_margin

      @svg = @create_svg_container @width, @series_height, @margins

      @display_legend()

      columns = @get_columns()

      @x = d3.scale.ordinal()
        .rangeRoundBands([0, @width - @margins.right])
        .domain(columns.map((col) -> col.key))

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 7])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 7])

      @bar_width = Math.round(@x.rangeBand() * 0.75)
      @bar_space = Math.round(@x.rangeBand() - @bar_width)

      # Year names.
      @svg.selectAll('text.year')
        .data(columns)
        .enter().append('svg:text')
        .attr('class', 'year small')
        .text((col) ->
          if col.period == 'present'
            App.settings.get('start_year')
          else
            App.settings.get('end_year')
        )
        .attr('x', (col) =>
          moveTogether = if col.period == 'present'
            (@bar_space / 2) - 2
          else
            (-@bar_space / 2) + 2

          @x(col.key) + 10 + moveTogether
        )
        .attr('dx', @bar_width / 2)
        .attr('y', @series_height + 15)
        .attr('text-anchor', 'middle')

      # Category names.
      @svg.selectAll('text.category')
        .data(columns)
        .enter().append('svg:text')
        .attr('class', 'category_label')
        .text((col) ->
          if col.name
            I18n.t("output_element_series.groups.#{col.name}")
          else
            ''
        )
        .attr('x', (col) =>
          @x(col.key) - (@bar_width / 2) + 1
        )
        .attr('dx', @bar_width / 2)
        .attr('y', @series_height + 32)
        .attr('text-anchor', 'middle')

      # Render the bars.
      rect = @svg.selectAll('rect.serie')
        .data(@stack_method(@prepare_data()), (s) -> s.id)
        .enter().append('svg:rect')
        .attr('class', (s) -> "serie #{s.period}")
        .attr("width", @bar_width)
        .attr('x', (s) =>
          # Push the present and future bars together by moving the present to
          # the right, and the future to the left.
          #
          # '-1'/'+1' to have a small space between the two bars.
          moveTogether = if s.period == 'present'
            (@bar_space / 2) - 2
          else
            (-@bar_space / 2) + 2

          # Rounding prevents some aliasing artifacts in Chrome.
          Math.round(@x(s.x) + 10 + moveTogether)
        )
        .attr('data-tooltip-title', (s) => s.label)
        .attr('y', @series_height)
        .style('fill', (d) => d.color)

      # Draw a nice axis
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

      # Target lines.
      @svg.selectAll('rect.target_line')
        .data(@prepare_target_data(), (d) -> d.id)
        .enter()
        .append('svg:rect')
        .attr('class', (s) -> "target_line #{s.period}")
        .style('fill', (d) -> d.color)
        .attr('height', 2)
        .attr('width', @bar_width + 4)
        .attr('x', (serie) =>
          moveTogether = if serie.period == 'present'
            (@bar_space / 2) - 4
          else
            (-@bar_space / 2)

          Math.round(@x(serie.x) + 10 + moveTogether)
        )
        .attr('y', 0)

      # Tooltips.
      $("#{@container_selector()} rect.serie").qtip
        content:
          title: -> $(this).attr('data-tooltip-title')
          text:  -> $(this).attr('data-tooltip-text')
        position:
          target: 'mouse'
          my: 'bottom center'
          at: 'top center'

    refresh: =>
      tallest = _.max(@categories.map (c) -> c.maxValue()) * 1.05

      # Update the scales as needed.
      @y = @y.domain([0, tallest]).nice()
      @inverted_y = @inverted_y.domain([0, tallest]).nice()

      @y_axis.tickFormat(@main_formatter())

      # Animate the y-axis.
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      @svg.selectAll('rect.serie')
        .data(@stack_method(@prepare_data()), (s) -> s.id)
        .transition()
        .attr('y', (d) => @series_height - @y(d.y0 + d.y))
        .attr('height', (d) => @y(d.y))
        .attr("data-tooltip-text", (d) => @main_formatter()(d.y))

      # Move the target lines
      @svg.selectAll('rect.target_line')
        .data(@prepare_target_data(), (d) -> d.id)
        .transition()
        .attr('y', (d) => Math.round(@series_height - @y(d.y)))

      @display_legend()

    get_columns: =>
      _.flatten(@categories.map((category) -> category.columns()))

    display_legend: =>
      $(@container_selector()).find('.legend').remove()

      series_for_legend = @prepare_legend_items()
      legend_columns = if series_for_legend.length > 4 then 2 else 1

      @draw_legend
        svg: @svg
        series: series_for_legend
        width: @width
        vertical_offset: @series_height + @legend_margin
        columns: legend_columns

    table_view_for: ->
      CategoryTableView

    prepare_legend_items: =>
      # Prepare legend
      # remove duplicate target series. Required for backwards compatibility.
      # When we'll drop the old charts we should use a single serie as target
      # rather than two.
      #
      # Also checks if series have a significant value i.e. a value larger than
      # 0.0000001 otherwise it doesn't get added to the legend.
      seen_labels = []

      target_series = []
      legend_series = []

      for series in @series
        label = series.get('label')
        total = Math.abs(series.safe_future_value()) +
                Math.abs(series.safe_present_value())

        if (series.get('is_target_line') || total > 1e-7) &&
            _.indexOf(seen_labels, label) == -1
          seen_labels.push(label)

          if series.get('is_target_line')
            target_series.push(series)
          else
            legend_series.push(series)

      legend_series.reverse()

      # Show "target" lines first.
      legend_series = legend_series.concat(target_series)

      legend_series

    # the stack layout method expects data to be in a precise format. We could
    # force the values() method but this way is simpler and cleaner.
    prepare_data: =>
      columns = []

      @categories.map (category) ->
        presentVals = []
        futureVals = []

        category.valueSeries.map (serie) ->
          presentVals.push({
            x: "#{serie.get('group')}_present",
            y: serie.safe_present_value(),
            id: "#{serie.get('gquery_key')}_present",
            color: serie.get('color'),
            label: serie.get('label'),
            period: 'present'
          })

          futureVals.push({
            x: "#{serie.get('group')}_future",
            y: serie.safe_future_value(),
            id: "#{serie.get('gquery_key')}_future",
            color: serie.get('color'),
            label: serie.get('label'),
            period: 'future'
          })

        columns.push(presentVals)
        columns.push(futureVals)

      columns

    prepare_target_data: =>
      data = []

      @categories.map (category) ->
        category.targetSeries.map (serie) ->
          if serie.get('target_line_position') == '1'
            data.push({
              x: "#{serie.get('group')}_present",
              y: serie.safe_present_value(),
              id: "#{serie.get('gquery_key')}_present",
              color: serie.get('color'),
              label: serie.get('label'),
              period: 'present'
            })
          else
            data.push({
              x: "#{serie.get('group')}_future",
              y: serie.safe_future_value(),
              id: "#{serie.get('gquery_key')}_future",
              color: serie.get('color'),
              label: serie.get('label'),
              period: 'future'
            })

      data
