# frozen_string_literal: true

FactoryBot.define do
  factory :saved_scenario_version do
    saved_scenario
    user

    scenario_id { rand(1..999_999) }
    message { 'A new version for this saved scenario' }
  end
end

