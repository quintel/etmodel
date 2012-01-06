FactoryGirl.define do
  factory :input_element do
    sequence(:key) {|n| "input_element_#{n}" }
    input_id 0
    after_create {|i| i.update_attribute(:input_id, i.id)}
  end
end