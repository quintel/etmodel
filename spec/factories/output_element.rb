FactoryGirl.define do
  factory :output_element_type do
    name 'test_chart'
  end

  factory :output_element do
    sequence(:key) {|n| "output_element_#{n}" }
    association :output_element_type
  end

  factory :output_element_serie do
    association :output_element, factory: :output_element
    gquery 'gquery_foobar'
  end

  factory :output_element_with_description, parent: :output_element do
    association :description, factory: :description
  end
end
