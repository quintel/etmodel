Factory.define :user do |user|
  user.name {"Username"}
  user.sequence(:email) {|n| "person#{n}@quintel.com" }
  user.password {"password"}
  user.password_confirmation {"password"}
end

Factory.define :admin, :parent => :user do |f|
  f.association :role, :factory => :admin_role
end
