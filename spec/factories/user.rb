Factory.define :user do |user|
  user.name {"Username"}
  
  user.sequence(:email) {|n| "person#{n}@quintel.com" }
  # user.email { "user@quintel.com" }
  user.password {"password"}
  user.password_confirmation {"password"}
end
