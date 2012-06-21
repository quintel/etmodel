# Pseudo-namespace for D3 charts
@D3 = {}

# This is mostly an abstract class
#
# The derived classes should implement the draw() method for the initial
# rendering and the refresh() for the later updates.
# They should also call @initialize_defaults() in their initialize method
class @D3ChartView extends BaseChartView
  render: (force_redraw) =>
    if force_redraw || !@already_on_screen()
      @$el.find(".chart_canvas").empty().html(@html())
      @draw()
    @refresh()

  already_on_screen: =>
    $('#' + @chart_container_id()).length == 1

  html: => "<div id='#{@chart_container_id()}' class='d3_container'></div>"

  chart_container_id: => "d3_container_#{@model.get 'key'}"

  can_be_shown_as_table: -> false

  block_ui_on_refresh: -> false

  supported_in_current_browser: ->
    if $.browser.msie && $.browser.version < 9
      false
    else
      true

