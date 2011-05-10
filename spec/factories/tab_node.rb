Factory.define :tab_node do |f|
  f.key 'TabNode'
  f.type 'TabNode'
  f.association :element, :factory => :tab
  f.association :parent, :factory => :root_node
end