Factory.define :input_element do |f|
  f.name 'an_input_element'
  f.sequence(:key) {|n| "input_element_#{n}" }
  f.input_id 0
  f.after_create {|i| i.update_attribute(:input_id, i.id)}
end