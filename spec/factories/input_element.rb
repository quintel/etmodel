FactoryBot.define do
  factory :input_element do
    sequence(:key) {|n| "input_element_#{n}" }
    sequence(:position) { |n| n }
  end
end
