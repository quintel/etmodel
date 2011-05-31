Factory.define :output_element_node, :class => 'ViewNode::OutputElement' do |f|
  f.association :parent, :factory => :slide_node
  f.association :element, :factory => :output_element  
end