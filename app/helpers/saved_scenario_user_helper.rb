# frozen_string_literal: true

# Helper methods for saved scenario users page
module SavedScenarioUserHelper
  def current_scenario_user?(saved_scenario_user)
    saved_scenario_user.user_id == current_user.id
  end

  def only_owner?(saved_scenario, saved_scenario_user)
    saved_scenario.single_owner? && current_scenario_user?(saved_scenario_user)
  end
end
