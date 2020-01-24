FactoryBot.define do
  factory :tab do
    sequence(:key) {|n| "tab_#{n}" }
    sequence(:position) { |n| n }
  end
end
