$ ->
  for c in $("#dashboard_popup .chart")
    chart_id = $(c).data('chart_id')
    wrapper = $(c).data('wrapper') || '#charts'
    charts.load chart_id,
                null, # create the holder automatically
                {header: false, wrapper: wrapper, prunable: true}
