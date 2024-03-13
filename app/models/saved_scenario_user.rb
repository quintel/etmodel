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

  private

  # Either user_id or user_email should be present, but not both
  def user_id_or_email
    return if user_id.blank? ^ user_email.blank?

    errors.add(
      :base,
      :user_or_email_blank,
      message: 'Either user_id or user_email should be present.'
    )
  end

  def ensure_one_owner_left_before_save
    # Don't check new records and ignore if the role is set to owner.
    return if new_record? || role_id == User::ROLES.key(:scenario_owner)

    ensure_last_owner
  end

  def ensure_one_owner_left_before_destroy
    # If the saved_scenario or user is getting destroyed, skip this validation
    return if destroyed_by_association
    return unless role_id == User::ROLES.key(:scenario_owner)

    ensure_last_owner
  end

  def last_owner?
    saved_scenario
      .saved_scenario_users.where.not(id: id)
      .pluck(:role_id).compact.uniq
      .none?(User::ROLES.key(:scenario_owner))
  end

  def ensure_last_owner
    return unless last_owner?

    errors.add(:base, :ownership, message: 'Last owner cannot be altered')
    throw(:abort)
  end
end
