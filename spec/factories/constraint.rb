FactoryGirl.define do
  factory :constraint do
    key 'bar'
    group Constraint::GROUPS.sample # pick a random group
  end
end