Factory.define :sidebar_item_node, :class => 'ViewNode::SidebarItem' do |f|
  f.association :parent, :factory => :tab_node
  f.association :element, :factory => :sidebar_item
end