# Pseudo-namespace for D3 charts
@D3 = {}

# This is mostly an abstract class
#
# The derived classes should implement the draw() method for the initial
# rendering and the refresh() for the later updates.
# They should also call @initialize_defaults() in their initialize method
class @D3ChartView extends BaseChartView
  initialize: ->
    @key = @model.get 'key'
    @start_year = App.settings.get('start_year')
    @end_year = App.settings.get('end_year')
    @initialize_defaults()

  # Update margins to reflect font-size
  init_margins: =>
    fontSize = d3.select('body').style('font-size')
    return unless fontSize && fontSize.match(/\d+px/)

    multiplier = parseInt(fontSize, 10) / 13
    return if multiplier is 1

    @margins = _.reduce(
      _.keys(@margins),
      (memo, key) => memo[key] = Math.ceil(@margins[key] * multiplier); memo,
      {}
    )

    # Self-destruct.
    @init_margins = =>

  render: (force_redraw) =>
    return false unless @model.supported_by_current_browser()

    if @model.get('requires_merit_order')
      @check_merit_enabled()

      unless App.settings.merit_order_enabled()
        @drawn = false
        return

    if force_redraw || !@drawn
      @clear_container()
      @container_node().html(@html())
      @draw()
      @drawn = true

    @refresh()
    @display_empty_message()

  is_empty: =>
    false

  display_empty_message: =>
    EmptyChartMessage.display(this)

  html: =>
    type = @model.get 'type'
    if type == 'd3' then type = @model.get('key')
    "<div id='#{@chart_container_id()}' class='d3_container #{type}'></div>"

  chart_container_id: => "d3_#{@model.get 'key'}_#{@model.get 'container'}"

  container_selector: => "##{@chart_container_id()}"

  can_be_shown_as_table: -> false

  block_ui_on_refresh: -> false

  supported_in_current_browser: ->
    if $.browser.msie && $.browser.version < 9
      false
    else
      true

  canvas: => @$el.find('.chart_canvas')

  available_width: -> @canvas().width()

  available_height: -> @canvas().height()

  # Default values, derived class might have different values
  margins:
    top: 20
    bottom: 20
    left: 20
    right: 30

  # Returns a [width, height] array
  available_size: => [
    @available_width() - (@margins.left + @margins.right),
    @available_height() - (@margins.top + @margins.bottom)
  ]

  # Returns a D3-selected SVG container
  #
  create_svg_container: (width, height, margins, klass = '') =>
    d3.select(@container_selector())
      .append("svg:svg")
      .attr("height", height + margins.top + margins.bottom)
      .attr("width", width + margins.left + margins.right)
      .attr('class', klass)
      .append("svg:g")
      .attr("transform", "translate(#{margins.left}, #{margins.top})")

  legend_click: (d) => d

  # Builds a standard legend. Options hash:
  # - series: array of series. The label might be its 'label' attribute or its
  #           'key' attribute, which is translated with I18n.js
  # - columns: number of columns (default: 1)
  # - left_margin: (default: 10)
  #
  draw_legend: (opts = {}) =>
    opts.columns         = opts.columns || 1
    opts.left_margin     = opts.left_margin || 10
    legend_item_width    = (opts.width - opts.left_margin) / opts.columns

    series = opts.series.reverse().chunk(opts.columns)

    legend = d3.select(@container_selector())
      .append('div')
      .attr("class", "legend")
      .style("margin-left", "#{ opts.left_margin + @margins.left }px")
      .selectAll(".legend-column")
      .data(series)
      .enter()
      .append("div")
      .attr("class", "legend-column")
      .style('width', "#{ legend_item_width }px")

    legend_click = @legend_click

    d3.selectAll(".legend-column").each((items) ->
      scope = d3.select(this)
                .selectAll(".legend-item")
                .data(items)
                .enter()
                .append('div')
                .attr("class", "legend-item")
                .classed("hidden", (d) -> d.get('skip'))
                .classed("target_line", (d) -> d.get('is_target_line'))
                .on('click', (d) -> legend_click(d))

      scope.append("span")
        .attr('class', 'rect')
        .style("background-color", (d) => d.get 'color')

      scope.append("span")
        .html((d) ->
          d.get('label') ||
           I18n.t("output_element_series.labels.#{d.get('key')}")
        )
    )

  # height of the legend item
  legend_cell_height: 15
