$ ->
  App = new AppView()

  # safe copy of the global settings
  settings = _.extend({}, globals.settings)

  # discard locked charts
  settings.locked_charts = {}

  App.settings = new Setting(settings)

  for c in $("body#constraint_popup .chart")
    chart_id = $(c).data('chart_id')
    wrapper = $(c).data('wrapper') || '#charts'
    charts.load chart_id,
                null, # create the holder automatically
                {header: false, wrapper: wrapper}
