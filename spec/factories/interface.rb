FactoryGirl.define do
  factory :tab do
    sequence(:key) {|n| "tab_#{n}" }
    sequence(:position) { |n| n }
  end

  factory :sidebar_item do
    sequence(:key) {|n| "sidebar_item_#{n}" }
    sequence(:position) { |n| n }
    association :tab, factory: :tab
  end

  factory :slide do
    sequence(:key) {|n| "slide_#{n}" }
    sequence(:position) { |n| n }
    association :sidebar_item, factory: :sidebar_item
    association :output_element, factory: :output_element
  end
end
