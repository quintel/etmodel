FactoryGirl.define do
  factory :converter, :class => :converter do
    name "converter_name"
    converter_id 1
  end

  factory :converter_demand, :class => :converter do
    name "converter_name"
    demand 10**9
  end
end