Factory.define :sidebar_item_node do |f|
  f.association :parent, :factory => :tab_node
  f.association :element, :factory => :sidebar_item
end