# frozen_string_literal: true
module MultiYearChartsHelper
  def can_use_as_myc_scenario?(saved_scenario)
    scenario = saved_scenario.scenario

    scenario.loadable? &&
      scenario.end_year == 2050 &&
      scenario.area_code == 'nl'
  end
end
