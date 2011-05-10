Factory.sequence :key do |n|
  "key_#{n}"
end

Factory.define :root_node do |f|
  f.key { Factory.next(:key)}  
end