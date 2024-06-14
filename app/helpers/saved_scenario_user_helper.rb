# frozen_string_literal: true

# Helper methods for saved scenario users page
module SavedScenarioUserHelper
  def current_scenario_user?(saved_scenario_user)
    saved_scenario_user.user_id == current_user.id
  end

  def only_owner?(saved_scenario, saved_scenario_user)
    saved_scenario.single_owner? && current_scenario_user?(saved_scenario_user)
  end

  def display_user_name_for(saved_scenario_user)
    if saved_scenario_user.user_email.present?
      saved_scenario_user.user_email
    elsif saved_scenario_user.user.present?
      saved_scenario_user.user.name
    else
      t('scenario.users.nameless')
    end
  end
end
