Factory.define :role do |f|
  f.name 'user'
end

Factory.define :admin_role, :parent => :role do |f|
  f.name 'admin'
end