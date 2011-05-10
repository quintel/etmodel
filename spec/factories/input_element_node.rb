Factory.define :input_element_node do |f|
  f.key 'foo'
  f.association :element, :factory => :input_element
  f.type 'InputElement'
end