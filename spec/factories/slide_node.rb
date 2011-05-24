Factory.define :slide_node, :class => 'ViewNode::Slide' do |f|
  f.association :parent, :factory => :sidebar_item_node
  f.association :element, :factory => :slide
end