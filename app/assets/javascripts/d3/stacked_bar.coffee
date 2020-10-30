# # A custom column stack method.
# #
# # Determines the y and y0 value for each series within a column. This allows us to stack series on
# # top of one another. Series which positive values are positioned above the zero axis, while those
# # with a negative value are positioned below.
# #
# # The series "y" value corresponds with its value; the "y0" is the sum of the
# # series which appear below. For example with three series:
# #
# #   * a: 10
# #   * b: 20
# #   * c: 10
# #
# # The values assigned will be:
# #
# #   * a - y: 10, y0: 0
# #   * b - y: 20, y0: 10
# #   * c - y: 10, y0: 30
# #
# # D3.js v2 does not support negative values in stacks. Newer versions (v6+) do support a "diverging"
# # stack methods which appears to support this.
# stackColumn = (series, zeroOffset) ->
#   positiveY = zeroOffset
#   negativeY = zeroOffset

#   series.map (serie) ->
#     if serie.y >= 0
#       serie.y0 = positiveY
#       positiveY += serie.y
#     else
#       negativeY -= Math.abs(serie.y)
#       serie.y0 = negativeY
#       serie.y = Math.abs(serie.y)

#     serie

# stacker = (data, zeroOffset) ->
#   _.flatten data.map (series) ->
#     stackColumn(series, zeroOffset)

# D3.stacked_bar =
#   View: class extends D3ChartView
#     initialize: ->
#       D3ChartView.prototype.initialize.call(this)
#       @series = @model.series.models
#       # the stack method will filter the data and calculate the offset
#       # for every item
#       @stack_method = (columns) =>
#         stacker(columns, Math.abs(@inverted_y.domain()[0]))

#     can_be_shown_as_table: -> true

#     margins:
#       top: 20
#       bottom: 20
#       left: 30
#       right: 60

#     legend_margin: 20

#     is_empty: =>
#       total = 0

#       @prepare_data().map (d) ->
#         total += (d.reduce (t,s) -> t.y + s.y)

#       total <= 0

#     draw: =>
#       [@width, @height] = @available_size()

#       @series_height = @height - @legend_margin

#       @svg = @create_svg_container @width, @series_height, @margins

#       @display_legend()

#       columns = @get_columns()

#       @x = d3.scale.ordinal().rangeRoundBands([0, @width])
#         .domain(columns)

#       @bar_width = @x.rangeBand() * 0.5

#       # show years
#       @svg.selectAll('text.year')
#         .data(columns)
#         .enter().append('svg:text')
#         .attr('class', 'year')
#         .text((d) -> d)
#         .attr('x', (d) => @x(d))
#         .attr('dx', @bar_width / 2)
#         .attr('y', @series_height + 15)
#         .attr('text-anchor', 'middle')

#       @y = d3.scale.linear().range([0, @series_height]).domain([0, 7])
#       @inverted_y = d3.scale.linear().range([@series_height, 0]).domain([0, 7])

#       @svg.selectAll('rect.negative-region')
#         .data([0])
#         .enter().append('svg:rect')
#         .attr('class', 'negative-region')

#       # there we go
#       rect = @svg.selectAll('rect.serie')
#         .data(@stack_method(@prepare_data()), (s) -> s.id)
#         .enter().append('svg:rect')
#         .attr('class', 'serie')
#         .attr("width", @bar_width)
#         .attr('x', (s) => @x(s.x) + 10)
#         .attr('data-tooltip-title', (s) => s.label)
#         .attr('y', @series_height)
#         .style('fill', (d) => d.color)

#       $("#{@container_selector()} rect.serie").qtip
#         content:
#           title: -> $(this).attr('data-tooltip-title')
#           text:  -> $(this).attr('data-tooltip-text')
#         position:
#           target: 'mouse'
#           my: 'bottom center'
#           at: 'top center'

#       # draw a nice axis
#       @y_axis = d3.svg.axis()
#         .scale(@inverted_y)
#         .ticks(5)
#         .tickSize(-@width, 10, 0)
#         .orient("right")
#         .tickFormat(@main_formatter())
#       @svg.append("svg:g")
#         .attr("class", "y_axis inner_grid")
#         .attr("transform", "translate(#{@width - 25}, 0)")
#         .call(@y_axis)

#       # target lines
#       # An ugly thing in the target lines is the extra attribute called "target
#       # line position". If set to 1 then the target line must be shown on the
#       # first column only, if 2 only on the 2nd. The CO2 chart is different, too
#       @svg.selectAll('rect.target_line')
#         .data(@model.target_series(), (d) -> d.get 'gquery_key')
#         .enter()
#         .append('svg:rect')
#         .attr('class', 'target_line')
#         .style('fill', (d) -> d.get 'color')
#         .attr('height', 2)
#         .attr('width', @x.rangeBand() * .6)
#         .attr('x', (s) =>
#           column = if s.get('target_line_position') == '1' # Brrrrr
#             'start_year'
#           else
#             'end_year'
#           @x(App.settings.get column) - (@x.rangeBand() * .02))
#         .attr('y', 0)

#     refresh: =>
#       tallest = (@model.max_series_value() || 0) * 1.05
#       smallest = Math.min(@model.min_series_value(), 0)

#       # update the scales as needed
#       @y = @y.domain([0, Math.abs(smallest) + tallest])
#       @inverted_y = @inverted_y.domain([smallest, tallest])

#       @y_axis.tickFormat(@main_formatter())

#       # animate the y-axis
#       @svg.selectAll(".y_axis").transition().call(@y_axis.scale(@inverted_y))

#       # If the chart has negative values, make the tick line corresponding with value 0 fully
#       # black.
#       @svg.selectAll('.y_axis .tick')
#         .attr('class', (d) -> if smallest < 0 && d == 0 then 'tick bold' else 'tick')

#       @svg.selectAll('rect.negative-region')
#         .data([Math.abs(smallest)])
#         .transition()
#         .attr('height', (d) => @y(d))
#         .attr('width', @width)
#         .attr('x', 0 - @margins.left + 5)
#         .attr('y', (d) => @series_height - @y(d))

#       @svg.selectAll('rect.serie')
#         .data(@stack_method(@prepare_data()), (s) -> s.id)
#         .transition()
#         .attr('y', (d) => @series_height - @y(d.y0 + d.y))
#         .attr('height', (d) => @y(Math.abs(d.y)))
#         .attr("data-tooltip-text", (d) => @main_formatter()(d.value))

#       # move the target lines
#       @svg.selectAll('rect.target_line')
#         .data(@model.target_series(), (d) ->
#           "#{ d.get('gquery_key') }_#{ d.get('target_line_position') }"
#         )
#         .style 'opacity', (d) =>
#           if d.get('target_line_position') is '1'
#             if d.present_value() == null then 0 else 1
#           else
#             if d.future_value() == null then 0 else 1
#         .transition()
#         .attr 'y', (d) =>
#           value = if d.get('target_line_position') is '1'
#             Math.abs(smallest) + d.safe_present_value()
#           else
#             Math.abs(smallest) + d.safe_future_value()

#           @series_height - @y(value)


#       @display_legend()

#       # draw grid

#     get_columns: =>
#       result = [@start_year, @end_year]
#       if @model.year_1990_series().length
#         result.unshift(1990)
#       result

#     display_legend: =>
#       $(@container_selector()).find('.legend').remove()

#       series_for_legend = @prepare_legend_items()
#       legend_columns = if series_for_legend.length > 6 then 2 else 1

#       @draw_legend
#         svg: @svg
#         series: series_for_legend
#         width: @width
#         vertical_offset: @series_height + @legend_margin
#         columns: legend_columns

#     prepare_legend_items: =>
#       # Prepare legend
#       # remove duplicate target series. Required for backwards compatibility.
#       # When we'll drop the old charts we should use a single serie as target
#       # rather than two.
#       #
#       # Also checks if series have a significant value i.e. a value larger than
#       # 0.0000001 otherwise it doesn't get added to the legend.
#       target_lines = []
#       series_for_legend = []

#       for s in @series
#         label = s.get 'label'
#         total = Math.abs(s.safe_future_value()) +
#                 Math.abs(s.safe_present_value())

#         if s.get 'is_target_line'
#           if _.indexOf(target_lines, label) == -1
#             target_lines.push label
#             series_for_legend.push s
#           # otherwise the target line has already been added
#         else if total > 1e-7
#           series_for_legend.push s

#       series_for_legend

#     # the stack layout method expects data to be in a precise format. We could
#     # force the values() method but this way is simpler and cleaner.
#     prepare_data: =>
#       year_1990 = []
#       @model.year_1990_series().forEach (s) ->
#         year_1990.push(
#           {
#             x: 1990
#             y: Math.abs(s.safe_present_value()),
#             value: s.safe_present_value()
#             id: "#{s.get 'gquery_key'}_1990"
#             color: s.get('color')
#             label: s.get('label')
#           })

#       present = []
#       future = []
#       @model.non_target_series().forEach (s) ->
#         present.push(
#           {
#             x: App.settings.get('start_year')
#             y: Math.abs(s.safe_present_value())
#             value: s.safe_present_value()
#             id: "#{s.get 'gquery_key'}_present"
#             color: s.get('color')
#             label: s.get('label')
#           })
#         future.push(
#           {
#             x: App.settings.get('end_year')
#             y: s.safe_future_value()
#             value: s.safe_future_value()
#             id: "#{s.get 'gquery_key'}_future"
#             color: s.get('color')
#             label: s.get('label')
#           })

#       result = [present, future]
#       if year_1990.length
#         result.unshift(year_1990)
#       result
