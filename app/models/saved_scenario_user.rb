# frozen_string_literal: true

class SavedScenarioUser < ApplicationRecord
  belongs_to :saved_scenario
  belongs_to :user, optional: true

  validate :user_id_or_email
  validates :user_email, 'valid_email_2/email': true, allow_blank: true
  validates :role_id, inclusion: { in: User::ROLES.keys }

  # Always make sure one owner is left on the SavedScenario this record is part of
  # before changing its role or removing it.
  before_save :ensure_one_owner_left_before_save
  before_destroy :ensure_one_owner_left_before_destroy

  # Either user_id or user_email should be present, but not both
  def user_id_or_email
    return if user_id.blank? ^ user_email.blank?

    errors.add(:base, 'Either user_id or user_email should be present.')
  end

  def ensure_one_owner_left_before_save
  # Don't check new records and ignore if the role is set to owner.
    return if new_record? || role_id == User::ROLES.key(:scenario_owner)

    # Collect roles for other users of this scenario
    other_role_ids = saved_scenario.saved_scenario_users.where.not(id: id).pluck(:role_id).compact.uniq

    # Cancel this action of none of the other users is an owner
    throw(:abort) if other_role_ids.none?(User::ROLES.key(:scenario_owner))
  end

  def ensure_one_owner_left_before_destroy
    # Collect roles for other users of this scenario
    other_users = saved_scenario.saved_scenario_users.where.not(id: id)
    other_role_ids = other_users.pluck(:role_id).compact.uniq

    # Cancel this action of there are other users and none of them is an owner
    throw(:abort) if other_users.count > 0 && other_role_ids.none?(User::ROLES.key(:scenario_owner))
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
