Factory.define :input_element do |f|
  f.name 'an_input_element'
  f.sequence(:key) {|n| "input_element_#{n}" }
end