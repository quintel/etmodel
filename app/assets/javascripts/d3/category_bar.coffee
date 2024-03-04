categoriesFromSeries = (series, periods) ->
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
    new D3.category_bar.Category(groupName, grouped[groupName], periods)

# A custom column stack method.
#
# Determines the y and y0 value for each series within a column. This allows us to stack series on
# top of one another. Series which positive values are positioned above the zero axis, while those
# with a negative value are positioned below.
#
# The series "y" value corresponds with its value; the "y0" is the sum of the
# series which appear below. For example with three series:
#
#   * a: 10
#   * b: 20
#   * c: 10
#
# The values assigned will be:
#
#   * a - y: 10, y0: 0
#   * b - y: 20, y0: 10
#   * c - y: 10, y0: 30
#
# D3.js v2 does not support negative values in stacks. Newer versions (v6+) do support a "diverging"
# stack methods which appears to support this.
stackColumn = (series, zeroOffset) ->
  positiveY = zeroOffset
  negativeY = zeroOffset

  series.map (serie) ->
    if serie.y >= 0
      serie.y0 = positiveY
      positiveY += serie.y
    else
      negativeY -= Math.abs(serie.y)
      serie.y0 = negativeY
      serie.y = Math.abs(serie.y)

    serie

# stacker = (data, zeroOffset) ->
#   stackColumn(series, zeroOffset)

nonNegativeValue = (value) ->
  if value < 0 then 0 else value

nonPositiveValue = (value) ->
  if value > 0 then 0 else value

safeSerieValue = (serie, period) ->
  if period == 'present'
    serie.safe_present_value()
  else
    serie.safe_future_value()

D3.category_bar =
  # Contains information about, and series for, a category.
  Category: class Category
    constructor: (@key, @series, @periods) ->
      @targetSeries = @series.filter((serie) -> serie.get('is_target_line'))
      @valueSeries = @series.filter((serie) -> !serie.get('is_target_line'))

    minMaxValues: (valueFilter) =>
      @periods.map((period) => [
        d3.sum(@valueSeries.map((serie) -> valueFilter(safeSerieValue(serie, period)))),
        @targetSeries.map((serie) -> valueFilter(safeSerieValue(serie, period)))
      ]).flat(3)

    # The category max is the highest target series, or the sum of all
    # non-target series.
    maxValue: () ->
      d3.max(@minMaxValues(nonNegativeValue))

    minValue: () ->
      d3.min(@minMaxValues(nonPositiveValue))

    # Columns which will be rendered on the chart to show the category data.
    columns: () ->
      @periods.map((period) =>
        { key: "#{@key}_#{period}", name: @key, period: period, category: this }
      )

  # The category bar view.
  View: class extends D3ChartView
    initialize: ->
      D3ChartView.prototype.initialize.call(this)
      @series = @model.series.models

      # the stack method will filter the data and calculate the offset
      # for every item
      @stack_method = (column) ->
        stackColumn(column, Math.abs(@inverted_y.domain()[0]))

    can_be_shown_as_table: -> true

    margins:
      top: 20
      bottom: 40
      left: 20
      right: 50

    legend_margin: 20

    is_empty: =>
      !@categories.some((category) -> category.minValue() != 0 || category.maxValue() != 0)

    periods: ->
      if @model.get('config') && @model.get('config').period
        [@model.get('config').period]
      else
        ['present', 'future']

    totals_for_table: ->
      @model.get('config') && @model.get('config').show_total_row

    draw: =>
      self = this

      @categories = categoriesFromSeries(@series, @periods())

      [@width, @height] = @available_size()

      if @periods().length < 2
        # The years will not be shown; margins can be reduced.
        @margins.bottom = 20
        @legend_margin = 0

      @series_height = @height - @legend_margin

      @svg = @create_svg_container @width, @series_height, @margins

      @display_legend()

      columns = @get_columns()

      @x = d3.scale.ordinal()
        .rangeRoundBands([0, @width - @margins.right])
        .domain(columns.map((col) -> col.key))

      @y = d3.scale.linear().range([0, @series_height]).domain([0, 1])
      @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 1])

      # Scales and spacing
      # ------------------

      # The "inner" area of the chart contains all the columns. This allow us a little extra padding
      # around the left- and right-most categories.
      wrapper_width = (@width - @margins.right)

      # The total amount of space available to each category, including padding.
      # category_bandwidth_outer = (@width - @margins.right) / @categories.length

      # This amount of padding is added to the left and right of each category area, so that
      # categories are separated. This is scale.padding() in D3v6.
      space_per_category = wrapper_width / @categories.length
      category_padding = space_per_category * 0.1
      category_bandwidth = space_per_category * 0.8

      @category_x = d3.scale.ordinal()
        .rangeRoundBands([0, category_bandwidth * @categories.length])
        .domain(@categories.map((category) -> category.key))

      @year_x = d3.scale.ordinal()
        .rangeRoundBands([0, @category_x.rangeBand()])
        .domain(@categories[0] && @categories[0].periods || [])


      # Determine width and padding for "period" bars within each category. Target overhang is used
      # to allow the target lines to be slightly wider than the bars in the column.
      if @year_x.domain().length == 1
        bar_width = Math.round(@year_x.rangeBand())
        bar_padding = 0
        target_overhang = category_padding / 4
      else
        bar_width = Math.round(@year_x.rangeBand() * 0.95);
        bar_padding = Math.round(@year_x.rangeBand() - bar_width)
        target_overhang = bar_padding

      # Drawing
      # -------

      @svg.selectAll('rect.negative-region')
        .data([0])
        .enter().append('svg:rect')
        .attr('class', 'negative-region')

      # Categories
      categoryEls = @svg.selectAll('g.category-group')
        .data(@categories, (category) -> category.key)
        .enter()
        .append('svg:g')
        .attr('class', 'category-group')
        .attr(
          'transform',
          (d, i) => "translate(#{@category_x(i) + category_padding * (i * 2 + 1)},0)"
        )

      # Category labels.
      categoryEls
        .append('svg:text')
        .attr('class', 'category_label')
        .text((cat) -> if cat.key then I18n.t("output_element_series.groups.#{cat.key}") else '')
        .attr('x', category_bandwidth / 2)
        .attr('y', @series_height + (if @year_x.domain().length > 1 then 32 else 17))
        .attr('text-anchor', 'middle')

      # Add SVG groups for each column.
      yearColEls = categoryEls.selectAll('g.column')
        .data(
          (category) -> category.columns(),
          (column) -> column.key
        )
        .enter().append('g')
        .attr('class', 'column')
        .attr('transform', (d, i) => "translate(#{@year_x(d.period) + (bar_padding * i)})")

      # Draw the rects for each series.
      yearColEls.selectAll('rect.serie')
        .data(
          (column) -> self.stack_method(self.prepare_column(column)),
          (serie) -> serie.id
        )
        .enter().append('svg:rect')
        .attr('class', (d) => "serie #{d.period}")
        .attr('data-tooltip-title', (d) => d.label)
        .attr('height', 0)
        .attr('width', bar_width)
        .attr('y', @series_height - @y(0))
        .style('fill', (d) => d.color)

      # Target lines.
      yearColEls.selectAll('rect.target_line')
        .data(
          (column) -> self.prepare_target_column(column),
          (d) -> d.id
        )
        .enter()
        .append('svg:rect')
        .attr('class', (s) -> "target_line #{s.period}")
        .style('fill', (d) -> d.color)
        .attr('height', 2)
        .attr('width', bar_width + target_overhang * 2)
        .attr('x', -target_overhang)
        .attr('y', 0)

      # Render the years, but only when more than one is shown.
      if @year_x.domain().length > 1
        yearColEls.selectAll('text.year')
          .data((column) -> [column.period])
          .enter().append('svg:text')
          .attr('class', 'year small')
          .text((period) ->
            if period == 'present'
              App.settings.get('start_year')
            else
              App.settings.get('end_year')
          )
          .attr('dx', bar_width / 2)
          .attr('y', @series_height + 15)
          .attr('text-anchor', 'middle')

      # Draw a nice axis
      @y_axis = d3.svg.axis()
        .scale(@inverted_y)
        .ticks(7)
        .tickSize(-@width, 10, 0)
        .orient("right")
        .tickFormat(@y_axis_formatter())

      @svg.append("svg:g")
        .attr("class", "y_axis inner_grid")
        .attr("transform", "translate(#{@width - 25}, 0)")
        .call(@y_axis)

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
      self = this

      tallest = d3.max(@categories.map (c) -> c.maxValue()) * 1.05
      smallest = Math.min(0, d3.min(@categories.map (c) -> c.minValue()) * 1.05)

      # Update the scales. Use a nice range for the inverted Y (e.g -2 to 2 rather than -1.8 to 1.8,
      # and use that as the basis for Y). Applying nice() to both scales may result in different
      # nice values being chosen.
      @inverted_y = @inverted_y.domain([smallest, tallest]).nice(@y_axis.ticks()[0])
      @y = @y.domain([0, Math.abs(@inverted_y.domain()[0]) + @inverted_y.domain()[1]])

      # If the chart has negative values, make the tick line corresponding with value 0 fully
      # black.
      @svg.selectAll('.y_axis .tick')
        .attr('class', (d) -> if smallest < 0 && d == 0 then 'tick bold' else 'tick')

      @svg.selectAll('rect.negative-region')
        .data([Math.abs(@inverted_y.domain()[0])])
        .transition()
        .attr('height', (d) => @y(d))
        .attr('width', @width - 5)
        .attr('x', 0 - @margins.left)
        .attr('y', (d) => @series_height - @y(d))

      @y_axis.tickFormat(@y_axis_formatter())

      # Animate the y-axis.
      @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

      categoryEls = @svg.selectAll('g.category-group')
        .data(@categories, (category) -> category.key)

      yearColEls = categoryEls.selectAll('g.column')
        .data(
          (category) -> category.columns(),
          (column) -> column.key
        )

      yearColEls.selectAll('rect.serie')
        .data(
          (column) -> self.stack_method(self.prepare_column(column)),
          (serie) -> serie.id
        )
        .transition()
        .attr('y', (d) => @series_height - @y(d.y0 + d.y))
        .attr('height', (d) => @y(d.y))
        .attr("data-tooltip-text", (d) => @main_formatter()(d.y))

      # Move the target lines
      yearColEls.selectAll('rect.target_line')
        .data(
          (column) -> self.prepare_target_column(column),
          (d) -> d.id
        )
        .transition()
        .attr('y', (d) => @inverted_y(d.y))

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

      include_present = @periods().includes('present')
      include_future  = @periods().includes('future')

      for series in @series
        label = series.get('label')

        total = (if include_future then Math.abs(series.safe_future_value()) else 0) +
                (if include_present then Math.abs(series.safe_present_value()) else 0)

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

    prepare_column: (column) ->
      column.category.valueSeries.map((serie) ->
        value = if column.period == 'present'
          serie.safe_present_value()
        else
          serie.safe_future_value()

        {
          x: "#{serie.get('group')}_#{column.period}",
          y: value
          id: "#{serie.get('gquery_key')}_#{column.period}",
          color: serie.get('color'),
          label: serie.get('label'),
          period: column.period
        }
      )

    prepare_target_column: (column) ->
      column.category.targetSeries.map((serie) ->
        value = if column.period == 'present'
          serie.safe_present_value()
        else
          serie.safe_future_value()

        {
          x: "#{serie.get('group')}_#{column.period}",
          y: value
          id: "#{serie.get('gquery_key')}_#{column.period}",
          color: serie.get('color'),
          label: serie.get('label'),
          period: column.period
        }
      )

    y_axis_formatter: (opts = {}) ->
      if @model.get('config') && @model.get('config').y_precision != undefined
        @main_formatter(Object.assign({ precision: @model.get('config').y_precision }, opts))
      else
        @main_formatter()
