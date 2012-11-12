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
      when 'line'
        if d3_support then D3.line.View else LineChartView
      when 'waterfall'
        if d3_support then D3.waterfall.View else WaterfallChartView
      when 'horizontal_stacked_bar' then HorizontalStackedBarChartView
      when 'grouped_vertical_bar'   then GroupedVerticalBarChartView
      when 'block'                  then BlockChartView
      when 'co2_emissions'
        if d3_support then D3.co2_emissions.View else CO2EmissionsChartView
      when 'html_table'             then HtmlTableChartView
      when 'scatter'
        if d3_support then D3.scatter.View else ScatterChartView
      when 'sankey'                 then D3.sankey.View
      when 'target_bar'             then D3.target_bar.View
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


  # takes care of the header links
  #
  update_buttons: =>
    r = @outer_container()

    # format links
    r.find("a.chart_format, a.table_format").hide()
    if @can_be_shown_as_table()
      if @view.display_as_table
        r.find("a.chart_format").show()
      else
        r.find("a.table_format").show()

    # update chart information link
    r.find(".actions a.chart_info").attr "href", "/descriptions/charts/#{@get 'id'}"
    # show.hide the under_construction notice
    r.find(".chart_not_finished").toggle @get("under_construction")

    # is this the default chart?
    try
      is_default = App.settings.get('charts')[holder_id].default == @get('id')
      r.find("a.default_chart").toggle(!is_default)
    catch e
      r.find("a.default_chart").hide()


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
      type = @get 'type'
      label = s.get 'label'
      if (type == 'mekko') || (type == 'horizontal_stacked_bar')
        label = "#{label} - #{s.get('group')}"
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
    return true if Browser.hasD3Support()
    _.indexOf(['d3', 'sankey', 'target_bar'], @get 'type') == -1

  delete: =>
    @view.unbind()
    @delete_gqueries()

  shown_as_table: => @view.display_as_table

  can_be_shown_as_table: => @view.can_be_shown_as_table()

  lock: =>
    @view.$el.find('a.pin_chart').removeClass('icon-unlock').addClass('icon-lock')
    @update_settings
      chart_id: @get 'id'
      format: if @shown_as_table() then 'table' else 'chart'

  unlock: =>
    @view.$el.find('a.pin_chart').removeClass('icon-lock').addClass('icon-unlock')
    @update_settings
      chart_id: false
      format: null

  update_settings: (opts) =>
    s = App.settings.get 'charts'
    holder = @get 'container'
    s[holder].format = opts.format
    s[holder].chart_id = opts.chart_id
    App.settings.save charts: s
