Factory.sequence :key do |n|
  "key_#{n}"
end

Factory.define :root_node, :class => 'ViewNode::Root' do |f|
  f.key { Factory.next(:key)}  
end