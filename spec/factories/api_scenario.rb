FactoryBot.define do
  factory :api_scenario, class: Engine::Scenario do
    country { "de" }

    area_code { 'nl' }
    title { 'My Scenario' }
    end_year { 2050 }
  end
end
