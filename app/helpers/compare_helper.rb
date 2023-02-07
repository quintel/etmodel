# frozen_string_literal: true

# Helpers for Compare (local-global)
module CompareHelper
  # Public: returns true if the saved scenario can be shown on the scenario picker
  # of the compare index page
  def eligible_for_compare?(saved_scenario)
    saved_scenario.scenario(engine_client)&.loadable?
  end
end
