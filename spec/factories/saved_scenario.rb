FactoryGirl.define do
  factory :saved_scenario do
    title "Some scenario"
    scenario_id 123
    association :user, factory: :user
  end
end
