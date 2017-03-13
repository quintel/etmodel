FactoryGirl.define do
  factory :saved_scenario do
    title "Some scenario"
    scenario_id 648695
    association :user, factory: :user
  end
end
