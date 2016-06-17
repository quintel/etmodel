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

  render: (force_redraw) =>
    return false unless @model.supported_by_current_browser()

    if force_redraw || !@drawn
      @clear_container()
      @container_node().html(@html())
      @draw()
      @drawn = true

    if @model.get('requires_merit_order')
      @check_merit_enabled()
      @drawn = App.settings.merit_order_enabled()

    @refresh()

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


  # Builds a standard legend. Options hash:
  # - svg: SVG container (required)
  # - series: array of series. The label might be its 'label' attribute or its
  #           'key' attribute, which is translated with I18n.js
  # - columns: number of columns (default: 1)
  # - left_margin: (default: 10)
  # - vertical_offset: equivalent to top margin (default: 0)
  #
  draw_legend: (opts = {}) =>
    opts.columns         = opts.columns || 1
    opts.left_margin     = opts.left_margin || 10
    opts.vertical_offset = opts.vertical_offset || 0
    legend_margin        = opts.width / opts.columns

    legend = opts.svg.append('svg:g')
      .attr("transform", "translate(#{opts.left_margin},#{opts.vertical_offset})")
      .selectAll("svg.legend")
      .data(opts.series)
      .enter()
      .append("svg:g")
      .attr("class", "legend")
      .attr("transform", (d, i) =>
        x = legend_margin * (i % opts.columns)
        y = Math.floor(i / opts.columns) * @legend_cell_height
        "translate(#{x}, #{y})")
      .attr("height", 30)
      .attr("width", 90)
    legend.append("svg:rect")
      .attr("width", 10)
      .attr("height", 10)
      .attr("fill", (d) => d.get 'color')
    legend.append("svg:text")
      .attr("x", 15)
      .attr("y", 10)
      .text((d) ->
        d.get('label') || I18n.t("output_element_series.#{d.get('key')}")
      )

  # height of the legend item
  legend_cell_height: 15
