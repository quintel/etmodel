FactoryBot.define do
  factory :saved_scenario do
    title { "Some scenario" }
    end_year { 2050 }
    area_code { 'nl' }
    scenario_id { 648695 }
    association :user, factory: :user
  end
end
