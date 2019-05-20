# frozen_string_literal: true

FactoryBot.define do
  factory :multi_year_chart do
    user

    area_code { 'nl' }
    title { 'My MultiYearChart' }
    end_year { 2050 }

    transient do
      scenarios_count { 2 }
    end

    after(:create) do |myc, evaluator|
      create_list(
        :multi_year_chart_scenario,
        evaluator.scenarios_count,
        multi_year_chart: myc
      )
    end
  end

  factory :multi_year_chart_scenario do
    multi_year_chart
    sequence(:scenario_id) { |n| n }
  end
end
