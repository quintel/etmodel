# This kind of chart has a different behaviour. It will read the gqueries from
# the markup (see app/views/output_elements/tables/_chart_*.html.haml). The cell
# data attributes will contain the key of the gquery and an optional :on_zero
# value, that will be used if the gquery returns zero.
# Old table charts still use gqueries defined in the db and arrange them in rows
# using the `order_by` attribute. Those should be converted.
#
# Some items require custom adaptations; to keep things clean they will
# be a subclass of this one
#
class @HtmlTableChartView extends BaseChartView
  initialize : ->
    @initialize_defaults()
    @build_gqueries()

  render : =>
    @clear_container()
    @container_node().html(@table_html())
    @fill_cells()
    @after_render()

    if @container_node().find(".merit_order_enabled").length > 0
      @check_merit_enabled()

  # The table HTML is provided by the rails app.
  #
  table_html: => @model.get 'html'

  # normal charts have their series added when the /output_element/X.js
  # action is called. Tables have the gqueries defined in the markup instead.
  # This method will parse the HTML and create the gqueries as needed.
  #
  build_gqueries: =>
    return if @gqueries_built
    html = $(@table_html())
    for cell in html.find("td[data-gquery]")
      gquery = $(cell).data('gquery')
      @model.series.add({gquery_key: gquery})
    @gqueries_built = true

  # The table is already in the DOM; let's find the cells whose content
  # is the result of a gquery and write the output
  #
  fill_cells: ->
    default_decimals = @container_node().find('.chart').data('decimals') || 1

    for cell in @dynamic_cells()
      gqid     = $(cell).data('gquery')
      unit     = $(cell).data('unit')
      decimals = $(cell).data('decimals') || default_decimals
      graph    = $(cell).data('graph') || 'future'
      serie    = @model.series.with_gquery(gqid)

      if !serie
        console.warn "Missing gquery: #{gqid}"
        return

      raw_value = if graph == 'future' then serie.future_value() else serie.present_value()
      raw_value = 0 unless _.isNumber(raw_value)
      value     = @main_formatter(maxFrom: 5, precision: decimals, maxPrecision: 5, scaledown: false, unit: unit)(raw_value)

      # some gqueries need a special treatment if they're 0
      on_zero = $(cell).data('on_zero')
      if raw_value == 0 and on_zero
        value = on_zero
      $(cell).html(value)

  # returns a jQuery collection of cells to be dynamically filled
  dynamic_cells: ->
    @container_node().find("td[data-gquery]")

  can_be_shown_as_table: -> false

  # Derived classes can override this
  after_render: => true

