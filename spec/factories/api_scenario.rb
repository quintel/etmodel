FactoryBot.define do
  factory :api_scenario, class: Api::Scenario do
    country { "de" }

    area_code { 'nl' }
    title { 'My Scenario' }
    end_year { 2050 }
  end
end
