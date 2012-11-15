$ ->
  # regular dashboard popups
  #
  for c in $("#dashboard_popup .chart")
    chart_id = $(c).data('chart_id')
    wrapper = $(c).data('wrapper') || '#charts'
    charts.load chart_id,
                null, # create the holder automatically
                {header: false, wrapper: wrapper, prunable: true}

  # targets popup
  #
  t.update_view() for t in window.targets.models

  # Bio-footprint popup
  #
  q = gqueries.find_or_create_by_key('dashboard_bio_footprint')
  present = q.safe_present_value()
  future  = q.safe_future_value()
  $("div.present .overlay").css('width', "#{70 * present}px")
  $("div.future  .overlay").css('width', "#{70 * future }px")

