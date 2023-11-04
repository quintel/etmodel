# frozen_string_literal: true

FactoryBot.define do
  factory :saved_scenario do
    transient do
      user { nil }
    end

    title { 'Some scenario' }
    end_year { 2050 }
    area_code { 'nl' }
    scenario_id { 648_695 }

    after(:create) do |saved_scenario, evaluator|
      if evaluator.user.present?
        saved_scenario.saved_scenario_users << create(
          :saved_scenario_user,
          user: evaluator.user,
          saved_scenario: saved_scenario
        )
      end
    end
  end
end
