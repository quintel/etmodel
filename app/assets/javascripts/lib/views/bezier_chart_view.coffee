class @BezierChartView extends JQPlotChartView
  initialize : ->
    @initialize_defaults()

  render: =>
    @pre_render()
    @render_chart()

  # if we scale the label we've got to scale the values, too
  scaled_results: ->
    scale = @data_scale()
    _.map @model.results(), (gquery) ->
      _.map gquery, (pair) ->
        [pair[0], Metric.scale_value(pair[1], scale)]

  formatted_results: ->
    @plot_series @scaled_results(), App.settings.get('start_year'), App.settings.get('end_year'), @model.get('growth_chart')

  render_chart: =>
    $.jqplot @container_id(), @formatted_results(), @chart_opts()

  chart_opts: =>
    grid: @defaults.grid,
    highlighter: @defaults.highlighter
    legend: @create_legend({num_columns: 2})
    stackSeries: false # this must be false! The series are stacked by summing the y-values
    seriesDefaults:
      renderer: $.jqplot.BezierCurveRenderer
      pointLabels:
        show: false
      yaxis: 'y2axis'
    seriesColors: @model.colors()
    axesDefaults: @defaults.stacked_line_axis_default
    axes:
      xaxis:
        numberTicks: 2 # only show present and future year
        tickOptions:
          showGridline: false
        ticks: [App.settings.get('start_year'), App.settings.get('end_year')]
      y2axis:
        rendererOptions:
          forceTickAt0: true # we always want a tick a 0
        borderColor: '#CCCCCC' # color for the marks #cccccc is the same as the grid lines
        tickOptions:
          formatString: "%.#{@significant_digits()}f&nbsp;#{@parsed_unit()}"

  # Bezier-realted stuff
  # RD: check http://alecjacobson.com/programs/bezieVr-curve/ for a nice bezier drawing tool!

  plot_series: (series,start_x,end_x,growth) ->
    result = []
    start_value = 0
    end_value = 0

    for serie in series
      start_y = serie[0][1] # get the present value of the serie
      start_value += start_y # the series are stacked, so sum the present value of the serie with the previous series.
      end_y = serie[1][1] # get the future value  of the serie
      end_value += end_y # the series are stacked, so sum the future value of the serie with the previous series.

      if growth # when the chart must display an exponential growth or exponential decrease render only 50% of the s curve
        if start_value > end_value
          result.push([[start_x, start_value], @set_decrease_ex_curve(start_x,end_x,start_value,end_value).concat([end_x, end_value])])
        else
          result.push([[start_x, start_value], @set_growth_ex_curve(start_x,end_x,start_value,end_value).concat([end_x, end_value])])
      else
        result.push([[start_x, start_value], @set_s_curve(start_x,end_x,start_value,end_value).concat([end_x, end_value])])
    result

  set_s_curve: (start_x,end_x,start_y,end_y) ->
    # RD: see https://img.skitch.com/20111025-cdxwbfqxehwhm92mcayb9xnj93.jpg for a visual
    start_handle_x = start_x + ((end_x - start_x) / 2)
    start_handle_y = start_y
    end_handle_x = end_x - ((end_x - start_x) / 4)
    end_handle_y = end_y
    [start_handle_x,start_handle_y,end_handle_x,end_handle_y]

  set_growth_ex_curve: (start_x,end_x,start_y,end_y) ->
    # RD: see https://img.skitch.com/20111025-q6jwcg56afy6gx5pc2esynrk3m.jpg for a visual
    start_handle_x = start_x + ((end_x - start_x) / 2)
    start_handle_y = start_y
    end_handle_x = end_x
    end_handle_y = end_y
    [start_handle_x,start_handle_y,end_handle_x,end_handle_y]

  set_decrease_ex_curve: (start_x,end_x,start_y,end_y) ->
    # RD: see https://img.skitch.com/20111025-mwbkap2s6axuwqiemc6hpiswjw.jpg for a visual
    start_handle_x = start_x + ((end_x - start_x) / 2)
    start_handle_y = end_y
    end_handle_x = end_x
    end_handle_y = end_y
    [start_handle_x,start_handle_y,end_handle_x,end_handle_y]
