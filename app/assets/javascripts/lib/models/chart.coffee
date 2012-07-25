class @Chart extends Backbone.Model
  defaults:
    'container': 'main_chart'

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
    type = @get('type')
    d3_support = Browser.hasD3Support() && !window.disable_d3
    view_class = switch type
      when 'bezier'
        if d3_support
          D3.bezier.View
        else
          BezierChartView
      when 'horizontal_stacked_bar' then HorizontalStackedBarChartView
      when 'mekko'
        if d3_support
          D3.mekko.View
        else
          MekkoChartView
      when 'waterfall'              then WaterfallChartView
      when 'vertical_stacked_bar'
        if d3_support
          D3.stacked_bar.View
        else
          VerticalStackedBarChartView
      when 'grouped_vertical_bar'   then GroupedVerticalBarChartView
      when 'policy_bar'             then PolicyBarChartView
      when 'line'                   then LineChartView
      when 'block'                  then BlockChartView
      when 'vertical_bar'           then VerticalBarChartView
      when 'html_table'             then HtmlTableChartView
      when 'scatter'                then ScatterChartView
      when 'd3'                     then @d3_view_factory()
      when 'sankey'                 then D3.sankey.View
      else HtmlTableChartView
    @view = new view_class
      model: this
      el: @outer_container()
    @view.update_title()
    @view

  # the container just holds the chart, the outer container has the chart
  # action links, title, etc.
  outer_container: => $('#' + @get('container')).parents(".chart_holder")

  # D3 charts have their own class. Let's make an instance of the right one
  # D3 is a pseudo-namespace. See d3_chart_view.coffee
  d3_view_factory: =>
    key = @.get 'key'
    if D3[key] && D3[key].View
      D3[key].View
    else
      throw "No such D3 chart: #{ key }"

  # @return [ApiResultArray] = [
  #   [[2010,0.4],[2040,0.6]],
  #   [[2010,20.4],2040,210.4]]
  # ]
  results : (exclude_target) ->
    if exclude_target
      series = @non_target_series()
    else
      series = @series.toArray()

    out = _(series).map (serie) -> serie.result()

    # policy goal charts show percentages but the gqueries return values
    # in the [0,1] range. Let's take care of that
    if @get('percentage')
      out = _(out).map (serie) ->
        [
          [ serie[0][0], serie[0][1] * 100 ],
          [ serie[1][0], serie[1][1] * 100 ]
        ]
    out

  colors : ->
    @series.map (serie) -> serie.get('color')

  labels : ->
    @series.map (serie) -> serie.get('label')

  # @return [Float] Only values of the present
  values_present: ->
    exclude_target_series = true
    _.map @results(exclude_target_series), (result) ->  result[0][1]

  # @return [Float] Only values of the future
  values_future : ->
    exclude_target_series = true
    _.map @results(exclude_target_series), (result) -> result[1][1]

  # @return [Float] All possible values. Helpful to determine min/max values
  values : ->
    _.flatten([@values_present(), @values_future()])

  # @return [[Float,Float]] Array of present/future values [Float,Float]
  value_pairs :->
    @series.map (serie) -> serie.result_pairs()

  non_target_series : ->
    @series.reject (serie) -> serie.get('is_target_line')

  target_series : ->
    @series.select (serie) -> serie.get('is_target_line')

  # @return Array of present and future target
  target_results : ->
    _.flatten _.map(@target_series(), (serie) -> serie.future_value())

  # @return Array of hashes {label, present_value, future_value}
  series_hash : ->
    @series.map (serie) ->
      label : serie.get('label')
      present_value : serie.present_value()
      future_value : serie.future_value()

  # This is used to show a chart as a table
  # See base_chart_view#render_as_table
  formatted_series_hash : ->
    # the @non_target_series() array is wrapped in underscore to fix an IE8 bug
    items = _(@non_target_series()).map (serie) =>
      label = serie.get 'label'
      label = "#{label} - #{serie.get('group')}" if @get('type') == 'mekko'
      out =
        label: label
        present_value: Metric.autoscale_value(serie.present_value(), @get('unit'), 2)
        future_value: Metric.autoscale_value(serie.future_value(), @get('unit'), 2)
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
    if @get('type') == 'd3' && !Browser.hasD3Support()
      false
    else
      true

  delete: =>
    @view.unbind()
    @delete_gqueries()

  shown_as_table: => @view.display_as_table

  can_be_shown_as_table: => @view.can_be_shown_as_table()
