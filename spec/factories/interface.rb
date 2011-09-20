FactoryGirl.define do
  factory :interface do
    sequence(:key) {|n| "interface_#{n}" }
    
    factory :simple_interface do
      structure {
        {
          :dashboard => [],
          :policy_goals => [],
          :tabs => {
            #::FactoryGirl.create(:tab).key => {
            'cost' => {
              ::FactoryGirl.create(:sidebar_item).key => {
                ::FactoryGirl.create(:slide).key => {
                  :input_elements => [ ::FactoryGirl.create(:input_element).key ],
                  :output_elements => [ ::FactoryGirl.create(:output_element).key ]
                }
              }
            }
          }
        }.to_yaml
      }
    end
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