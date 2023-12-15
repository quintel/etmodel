# frozen_string_literal: true

FactoryBot.define do
  factory :saved_scenario do
    transient do
      user { nil }
      saved_scenario_version { nil }
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

      if evaluator.saved_scenario_version.present?
        evaluator.saved_scenario_version.update(saved_scenario: saved_scenario)
        saved_scenario.update(saved_scenario_version_id: evaluator.saved_scenario_versions.id)
      else
        saved_scenario.saved_scenario_versions << create(
          :saved_scenario_version,
          saved_scenario: saved_scenario
        )
        saved_scenario.update(saved_scenario_version_id: saved_scenario.saved_scenario_versions.last.id)
      end
    end
  end
end
