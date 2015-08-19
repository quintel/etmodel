# The big picture: the chart object renders a chart that can be based on
# jqPlot (IE<9) or D3 (newer browsers). The chart will be rendered inside a
# holder element:
#
#     #charts_wrapper
#       .chart_holder
#         header           - optional
#         .chart_canvas#id - where the chart is actually rendered
#       .chart_holder      - the wrapper can hold multiple charts
#         ...
#
# The holder element is created dynamically using underscore templates; we can
# specify the element that will contain it; the default is #charts_wrapper,
# but popup elements might use something else
#
# TODO: the chart constructor immediately triggers the render method, although
# we could still be waiting for the API response. The event chain should be
# refactored.
#
class @Chart extends Backbone.Model
  initialize : ->
    # every chart has a series (=~ gqueries) collection. This helps us handling
    # them
    @series = switch @get('type')
      when 'block' then new BlockChartSeries()
      when 'scatter' then new ScatterChartSeries()
      else new ChartSeries()
    # this should be called later! It's still here for backwards compatibility
    # with the old jqplot charts. See ETPlugin charts for a better approach.
    @render()

  render : =>
    return false unless @supported_by_current_browser()

    klass = @find_view_class()
    @view = new klass(
      model: this
      el: @outer_container()
    )

    @view.update_header()

  # -- view class detection --------------------------------------------------

  find_view_class: =>
    d3_support = Browser.hasD3Support() && !window.disable_d3
    switch @get('type')
      when 'bezier'
        if d3_support then D3.bezier.View else BezierChartView
      when 'time_curve'
        D3.time_curve.View
      when 'mekko'
        if d3_support then D3.mekko.View else MekkoChartView
      when 'vertical_stacked_bar'
        if d3_support then D3.stacked_bar.View else VerticalStackedBarChartView
      when 'line'
        if d3_support then D3.line.View else LineChartView
      when 'waterfall'
        if d3_support then D3.waterfall.View else WaterfallChartView
      when 'horizontal_stacked_bar' then HorizontalStackedBarChartView
      when 'grouped_vertical_bar'   then GroupedVerticalBarChartView
      when 'block'                  then BlockChartView
      when 'co2_emissions'
        if d3_support then D3.co2_emissions.View else CO2EmissionsChartView
      when 'html_table'             then @table_view_factory()
      when 'scatter'
        if d3_support then D3.scatter.View else ScatterChartView
      when 'sankey'                    then D3.sankey.View
      when 'target_bar'                then D3.target_bar.View
      when 'd3'                        then @d3_view_factory()
      when 'storage'                   then D3.storage.View
      when 'import_export_cwe'         then D3.import_export_cwe.View
      when 'import_export_flows'       then D3.import_export_flows.View
      when 'import_export_renewables'  then D3.import_export_renewables.View
      when 'import_export_capacity'    then D3.import_export_capacity.View
      else throw "Chart type not available"

  # D3 charts have their own class. Let's make an instance of the right one
  # D3 is a pseudo-namespace. See d3_chart_view.coffee
  #
  d3_view_factory: =>
    key = @get 'key'
    if D3[key] && D3[key].View
      D3[key].View
    else
      throw "No such D3 chart: #{ key }"

  # Some tables have a different behaviour and inherit from the common class
  table_view_factory: =>
    switch @get('key')
      when 'merit_order_table' then MeritOrderTableView
      when 'plant_profitability' then PlantProfitabilityTableView
      else HtmlTableChartView

  # -- DOM and interface -----------------------------------------------------

  # the container just holds the chart, the outer container has the chart
  # action links, title, etc.
  outer_container: => $("##{@get 'container'}").parents(".chart_holder")

  # -- browser support -------------------------------------------------------

  supported_by_current_browser: =>
    return true if Browser.hasD3Support()
    _.indexOf(['d3', 'import_export_cwe', 'import_export_capacity', 'import_export_flows', 'import_export_renewables', 'sankey', 'storage', 'target_bar'], @get 'type') == -1

  # -- series and values -----------------------------------------------------

  # raw array of the associated gqueries. Delegates to the collection object
  #
  gqueries: => @series.gqueries()

  # @return [ApiResultArray] = [
  #   [[2010,0.4],[2040,0.6]],
  #   [[2010,20.4],2040,210.4]]
  # ]
  results : (exclude_target) ->
    series = if exclude_target
      @non_target_series()
    else
      @series.toArray()

    _(series).map (s) =>
      factor = if @get('precentage') then 100 else 1
      [
        [App.settings.get('start_year'), s.safe_present_value() * factor],
        [App.settings.get('end_year'),   s.safe_future_value()  * factor]
      ]

  colors : -> @series.map (s) -> s.get('color')

  labels : -> @series.map (s) -> s.get('label')

  # @return [Float] All possible values. Helpful to determine min/max values
  values : => _.flatten @value_pairs()

  values_present: => _.map @non_target_series(), (s) -> s.safe_present_value()

  values_future:  => _.map @non_target_series(), (s) -> s.safe_future_value()

  values_targets: => _.map @target_series(),     (s) -> s.safe_future_value()

  max_value: ->
    _.max([
      @values_present()...,
      @values_future()...,
      @values_targets()...
    ])

  max_series_value: ->
    _.max([
      _.sum(@values_present()),
      _.sum(@values_future()),
      @values_targets()...
    ])

  # @return [[Float,Float]] Array of present/future values [Float,Float]
  value_pairs: ->
    @series.map (s) -> [s.safe_present_value(), s.safe_future_value()]

  non_target_series: -> @series.reject (s) -> s.get('is_target_line')

  target_series: -> @series.select (s) -> s.get('is_target_line')

  format_value: (value) =>
    Metric.autoscale_value(value, @get('unit'), 2)

  # -- garbage stuff ---------------------------------------------------------

  delete: =>
    # update the settings object
    @toggle_lock(false) if @get 'locked'

    # don't leave stale event bindings and gqueries
    @view.unbind()
    @delete_gqueries()

  # let's get rid of the gqueries we don't need anymore. This is called when we
  # remove a chart and don't want stale gqueries lying around.
  #
  delete_gqueries: =>
    g.release() for g in @gqueries()
    gqueries.cleanup()

  # -- table format stuff ----------------------------------------------------

  can_be_shown_as_table: => @view.can_be_shown_as_table()

  # toggles between table and chart format, updating the settings as needed
  #
  toggle_format: =>
    current = @get 'as_table'
    @set 'as_table', !current
    # If the chart is locked let's lock the format, too
    @update_lock_settings() if @get 'locked'
    @view.toggle_format()

  # -- locking stuff ---------------------------------------------------------

  toggle_lock: (value = null) =>
    value = !@get('locked') if value == null
    @set 'locked', value
    @update_lock_settings()
    @view.update_lock_icon()

  # updates the settings hash and pushes the changes to the rails app
  #
  update_lock_settings: =>
    s = App.settings.get 'locked_charts'
    holder_id = @get 'container'

    if @get 'locked'
      tbl_string = if @get('as_table') then 'T' else 'C'
      s[holder_id] = "#{@get 'chart_id'}-#{tbl_string}"
    else
      delete s[holder_id]

    App.settings.save locked_charts: s

  # should the default button be shown?
  #
  wants_default_button: =>
    (@get('container') == 'holder_0') &&
    (@get('chart_id') != App.charts.default_chart_id)
