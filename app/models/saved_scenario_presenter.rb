# frozen_string_literal: true

# Creates JSON about a saved scenario, and the API scenario.
class SavedScenarioPresenter
  def initialize(saved_scenarios)
    @saved_scenarios = saved_scenarios
  end

  def as_json(*)
    @saved_scenarios.map do |saved_scenario|
      {
        saved_scenario_id: saved_scenario.id,
        scenario_id:       saved_scenario.scenario_id,
        title:             saved_scenario.title,
        dataset:           saved_scenario.area_code,
        end_year:          saved_scenario.end_year
      }
    end
  end
end
