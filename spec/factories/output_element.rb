Factory.define :output_element do |f|
  f.name 'an_output_element'
  f.sequence(:key) {|n| "output_element_#{n}" }
end