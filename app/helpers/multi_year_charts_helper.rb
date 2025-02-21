# frozen_string_literal: true
module MultiYearChartsHelper
  # Public: The full URL to the Multi-Year Charts application for an instance of
  # MultiYearCharts.
  #
  # Returns a string.
  def myc_url(multi_year_chart)
    "#{Settings.collections_url}/#{multi_year_chart.redirect_slug}?" \
      "locale=#{I18n.locale}&" \
      "title=#{ERB::Util.url_encode(multi_year_chart.title)}"
  end

  def can_use_as_myc_scenario?(saved_scenario)
    saved_scenario.loadable? && saved_scenario.end_year == 2050
  end
end
