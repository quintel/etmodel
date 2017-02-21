FactoryGirl.define do
  factory :prediction do
    title 'foobar'
    association :input_element, factory: :input_element
    expert true
    description 'This is a nice test discriprion'
    area 'nl'
    association :user, factory: :user
  end

  factory :prediction_measure do
    association :prediction, factory: :prediction
    name "This a name of the measure"
    impact 10
    cost  15
    year_start 2015
    year_end 2020
    actor "government"
    description "This is a nice test description for prediction measure"
  end

  factory :prediction_value do
    association :prediction, factory: :prediction
    min 2
    best 3
    max 4
    year 2050
  end
end
