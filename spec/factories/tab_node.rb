Factory.define :tab_node, :class => 'ViewNode::Tab' do |f|
  f.key 'TabNode'
  f.association :element, :factory => :tab
  f.association :parent, :factory => :root_node
end