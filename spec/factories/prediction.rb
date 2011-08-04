Factory.define :prediction do |f|
  f.title 'foobar'
  f.association :input_element, :factory => :input_element
  f.expert true
  f.curve_type nil
  f.description 'This is a nice test discriprion'
  f.association :user, :factory => :expert
end

Factory.define :expert, :class => User do |user|
  user.name {"Expert"}
  user.sequence(:email) {|n| "person#{n}@expert.com" }
  user.password {"password"}
  user.password_confirmation {"password"}
end
