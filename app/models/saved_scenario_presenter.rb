# frozen_string_literal: true

# Creates JSON about a saved scenario, and the API scenario.
class SavedScenarioPresenter
  def initialize(saved_scenarios)
    @saved_scenarios = saved_scenarios
  end

  def as_json(*)
    # When switching etengine db's not all referenced scenarios exist (dev only)
    @saved_scenarios.select(&:scenario).map do |saved_scenario|
      {
        saved_scenario_id: saved_scenario.id,
        scenario_id:       saved_scenario.scenario_id,
        title:             saved_scenario.scenario.title,
        dataset:           saved_scenario.scenario.area_code,
        end_year:          saved_scenario.scenario.end_year
      }
    end
  end
end
