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
      $("#d3_container").empty()
      @container_node().html(@html)
      @draw()
    @refresh()

  already_on_screen: =>
    @container_node().find("#d3_container").length == 1

  html: "<div id='d3_container'></div>"

  can_be_shown_as_table: -> false

  supported_in_current_browser: ->
    if $.browser.msie && $.browser.version < 9
      false
    else
      true

