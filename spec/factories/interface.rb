FactoryGirl.define do
  factory :interface do
    sequence(:key) {|n| "interface_#{n}" }
  end

  factory :tab do
    sequence(:key) {|n| "tab_#{n}" }
  end

  factory :slide do
    name 'this is a slide'
    sequence(:key) {|n| "slide_#{n}" }
  end

  factory :sidebar_item do
    name 'foo'
    sequence(:key) {|n| "sidebar_item_#{n}" }
  end
end