# frozen_string_literal: true

class SavedScenarioVersion < ApplicationRecord
  belongs_to :saved_scenario
  belongs_to :user

  validates :scenario_id, :message, presence: true
end

