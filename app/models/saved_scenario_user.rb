# frozen_string_literal: true

class SavedScenarioUser < ApplicationRecord
  belongs_to :saved_scenario
  belongs_to :user, optional: true

  validate :user_id_or_email

  def user_id_or_email
    unless user_id.present? || user_email.present?
      errors.add(:user_email, 'Email should be present if no user_id is given')

  # The following methods synchronize the user roles between
  # the SavedScenario and its Scenarios in ETEngine.
  def create_api_scenario_user(http_client)
    CreateAPIScenarioUser.call(http_client, saved_scenario.scenario_id, as_api_params)
    saved_scenario.scenario_id_history.each do |scenario_id|
      CreateAPIScenarioUser.call(http_client, scenario_id, as_api_params)
    end
  end

  def update_api_scenario_user(http_client)
    UpdateAPIScenarioUser.call(http_client, saved_scenario.scenario_id, as_api_params)
    saved_scenario.scenario_id_history.each do |scenario_id|
      UpdateAPIScenarioUser.call(http_client, scenario_id, as_api_params)
    end
  end

  def destroy_api_scenario_user(http_client)
    DestroyAPIScenarioUser.call(http_client, saved_scenario.scenario_id, as_api_params)
    saved_scenario.scenario_id_history.each do |scenario_id|
      DestroyAPIScenarioUser.call(http_client, scenario_id, as_api_params)
    end
  end

  def as_api_params(saved_scenario = nil)
    saved_scenario = self if saved_scenario.blank?

    {
      role: User::ROLES[saved_scenario.role_id],
      id: saved_scenario.user_id,
      email: saved_scenario.user_email
    }
  end
end
