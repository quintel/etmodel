class @D3ChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    unless @already_on_screen()
      @clear_container()
      @container_node().html(@html)
    @update_chart()

  already_on_screen: =>
    @container_node().find("#d3_container").length == 1

  html: "<div id='d3_container'>ciao</div>"

  update_chart: =>
    console.log "updating"

  can_be_shown_as_table: -> false
