class @Chart extends Backbone.Model
  defaults:
    container: 'chart_0'

  initialize : ->
    # every chart has a series (=~ gqueries) collection. This helps us handling
    # them
    @series = switch @get('type')
      when 'block' then new BlockChartSeries()
      when 'scatter' then new ScatterChartSeries()
      else new ChartSeries()
    @bind('change:type', @render)
    @render()

  render : =>
    return false unless @supported_by_current_browser()
    d3_support = Browser.hasD3Support() && !window.disable_d3
    view_class = switch @get('type')
      when 'bezier'
        if d3_support then D3.bezier.View else BezierChartView
      when 'mekko'
        if d3_support then D3.mekko.View else MekkoChartView
      when 'vertical_stacked_bar'
        if d3_support then D3.stacked_bar.View else VerticalStackedBarChartView
      when 'waterfall'              then WaterfallChartView
      when 'horizontal_stacked_bar' then HorizontalStackedBarChartView
      when 'grouped_vertical_bar'   then GroupedVerticalBarChartView
      when 'line'                   then LineChartView
      when 'block'                  then BlockChartView
      when 'vertical_bar'           then VerticalBarChartView
      when 'html_table'             then HtmlTableChartView
      when 'scatter'                then ScatterChartView
      when 'sankey'                 then D3.sankey.View
      when 'd3'                     then @d3_view_factory()
      else HtmlTableChartView
    @view = new view_class
      model: this
      el: @outer_container()
    @view.update_title()
    @view

  # the container just holds the chart, the outer container has the chart
  # action links, title, etc.
  outer_container: => $("##{@get 'container'}").parents(".chart_holder")

  # D3 charts have their own class. Let's make an instance of the right one
  # D3 is a pseudo-namespace. See d3_chart_view.coffee
  d3_view_factory: =>
    key = @get 'key'
    if D3[key] && D3[key].View
      D3[key].View
    else
      throw "No such D3 chart: #{ key }"

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

  # @return [[Float,Float]] Array of present/future values [Float,Float]
  value_pairs: ->
    @series.map (s) -> [s.safe_present_value(), s.safe_future_value()]

  non_target_series: -> @series.reject (s) -> s.get('is_target_line')

  target_series: -> @series.select (s) -> s.get('is_target_line')

  # This is used to show a chart as a table
  # See base_chart_view#render_as_table
  formatted_series_hash : ->
    # the @non_target_series() array is wrapped in underscore to fix an IE8 bug
    items = _(@non_target_series()).map (s) =>
      type = s.get 'type'
      label = s.get 'label'
      label = "#{label} - #{s.get('group')}" if type == 'mekko'
      unit = @get 'unit'
      out =
        label: label
        present_value: Metric.autoscale_value(s.safe_present_value(), unit, 2)
        future_value:  Metric.autoscale_value(s.safe_future_value(),  unit, 2)
    # some charts draw series bottom to top. Let's flip the array
    return items.reverse() if @get('type') in ['vertical_stacked_bar', 'bezier']
    items

  # raw array of the associated gqueries. Delegates to the collection object
  #
  gqueries: => @series.gqueries()

  # let's get rid of the gqueries we don't need anymore. This is called when we
  # remove a chart and don't want stale gqueries lying around.
  #
  delete_gqueries: =>
    g.release() for g in @gqueries()
    gqueries.cleanup()

  supported_by_current_browser: =>
    @get('type') != 'd3' || Browser.hasD3Support()

  delete: =>
    @view.unbind()
    @delete_gqueries()

  shown_as_table: => @view.display_as_table

  can_be_shown_as_table: => @view.can_be_shown_as_table()
