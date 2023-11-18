# frozen_string_literal: true

class SavedScenarioUser < ApplicationRecord
  belongs_to :saved_scenario
  belongs_to :user, optional: true

  validate :user_id_or_email
  validates :user_email, 'valid_email_2/email': true, allow_blank: true
  validates :role_id, inclusion: { in: User::ROLES.keys }

  # Always make sure one owner is left on the SavedScenario this record is part of
  # before changing its role or removing it.
  # Don't check new records and ignore if the role is set to owner.
  before_save :ensure_one_owner_left,
    unless: proc { |u| u.new_record? || u.role_id == User::ROLES.key(:scenario_owner) }
  before_destroy :ensure_one_owner_left

  # Either user_id or user_email should be present, but not both
  def user_id_or_email
    return if user_id.blank? ^ user_email.blank?

    errors.add(:base, 'Either user_id or user_email should be present.')
  end

  def ensure_one_owner_left
    # Collect roles for other users of this scenario
    role_ids = saved_scenario.saved_scenario_users.where.not(id: id).pluck(:role_id).compact.uniq

    # Cancel this action of none of the other users is an owner
    throw(:abort) if role_ids.none?(User::ROLES.key(:scenario_owner))
  end

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
