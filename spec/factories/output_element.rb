FactoryGirl.define do
  factory :output_element do
    name 'an_output_element'
    sequence(:key) {|n| "output_element_#{n}" }
  end

  factory :output_element_serie do
    association :output_element, :factory => :output_element
    gquery 'gquery_foobar'
  end
end