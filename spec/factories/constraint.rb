FactoryBot.define do
  factory :constraint do
    sequence(:key) {|n| "constraint_#{n}" }
    group Constraint::GROUPS.sample # pick a random group
  end
end
