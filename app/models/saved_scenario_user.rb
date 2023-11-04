# frozen_string_literal: true

class SavedScenarioUser < ApplicationRecord
  belongs_to :saved_scenario
  belongs_to :user, optional: true

  validate :user_id_or_email

  def user_id_or_email
    unless user_id.present? || user_email.present?
      errors.add(:user_email, 'Email should be present if no user_id is given')
    end
  end
end
