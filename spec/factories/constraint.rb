FactoryGirl.define do
  factory :constraint do
    name 'foo'
    key 'bar'
    group Constraint::GROUPS.sample # pick a random group
  end
end