FactoryGirl.define do
  factory :user do
    name "Username"
    sequence(:email) {|n| "person#{n}@quintel.com" }
    password "password"
    password_confirmation "password"
  end

  factory :admin, parent: :user do
    association :role, factory: :admin_role
  end
end
