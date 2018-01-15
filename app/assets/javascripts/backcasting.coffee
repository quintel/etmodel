//= require underscore
//= require jquery
//= require jquery_ujs
//= require jquery.busybox
//= require jqplot

$ ->
  # Chart series methods
  calculate_value = (x, years) ->
    base = 1 + x / 100.0
    Math.pow(base, years) * 100

  # returns a serie in the jqplot format
  # Move on the server side
  build_user_value_chart_serie = (user_value) ->
    # no interpolations or mid points, just draw a straight line
    if input_element.command_type == 'value'
      start_value = get_slider().get('start_value')
      out = [
        [scenario.start_year,start_value],
        [scenario.end_year, user_value]
      ]
    else if input_element.command_type == 'growth_rate'
      # draw a nice curve
      out = [[scenario.start_year, 100]]
      for i in [1..(scenario.end_year - scenario.start_year)]
        out.push([scenario.start_year + i, calculate_value(user_value, i)])
    else if(input_element.command_type == 'efficiency_improvement')
      # as above, inverted
      out = [[scenario.start_year, 100]]
      for i in [1..(scenario.end_year - scenario.start_year)]
        out.push([scenario.start_year + i, calculate_value(user_value, -i)])
    chart_data.series.unshift(out)
    chart_data.series_options.unshift({})

  # shows the bar with the scenario end year
  add_reference_bar = ->
    return if scenario.end_year == 2050

    # get the series values. It's a doubly nested array
    values = _.flatten _.map(
      chart_data.series, (x) ->
        _.map(x, (y) -> y[1])
      )

    min_value = if _.min(values) > 1 then 0 else _.min(values)
    chart_data.series.push(
      [[scenario.end_year, min_value],
       [scenario.end_year, _.max(values)]]
    )
    chart_data.series_options.push
      lineWidth: 3
      color: "#FFA013"
      markerOptions:
        show: false

  slider_is_available = ->
    parent && parent.App.input_elements

  set_slider_value = (x) ->
    return false unless slider_is_available()
    get_slider().set({ user_value : x })

  # returns the related input element
  get_slider = ->
    if !slider_is_available()
      return false
    parent.App.input_elements.get(input_element.id)

  plot_chart = ->
    # let's get the current slider value
    if scenario.available
      if slider_is_available()
        user_value = get_slider().get('user_value').toFixed(1)
        build_user_value_chart_serie(user_value)
        unit = get_slider().get('unit')
        $('#user_value').prepend(user_value+unit)
    add_reference_bar()

    # Let's plot the chart
    $.jqplot "backcasting", chart_data.series, {
        grid:
          background: '#ffffff'
          borderWidth: 0
          borderColor: '#ffffff'
          shadow: false
        axes:
          xaxis:
            tickOptions:
              formatString: '%.0f'
              showGridline: false
              numberTicks:5
          yaxis:
            tickOptions:
              formatString: '%.0f'
              numberTicks:5
              min: 0
        seriesColors: chart_data.colours
        series: chart_data.series_options
        seriesDefaults:
          markerOptions:
            show: false
          yaxis:'y2axis'
      }

  plot_chart()
