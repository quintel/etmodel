# frozen_string_literal: true
module MultiYearChartsHelper
  # Public: The full URL to the Multi-Year Charts application for an instance of
  # MultiYearCharts.
  #
  # Returns a string.
  def myc_url(multi_year_chart)
    [
      APP_CONFIG[:multi_year_charts_url],
      multi_year_chart.redirect_slug,
      'charts/final-demand'
    ].join('/')
  end

  def can_use_as_myc_scenario?(saved_scenario)
    scenario = saved_scenario.scenario

    scenario && (
      scenario.loadable? &&
      scenario.end_year == 2050 &&
      scenario.area_code == 'nl'
    )
  end
end
