Factory.define :input_element_node, :class => 'ViewNode::InputElement' do |f|
  f.key 'foo'
  f.association :element, :factory => :input_element
  f.type 'InputElement'
end