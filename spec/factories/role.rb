FactoryGirl.define do
  factory :role do
    name 'user'
  end

  factory :admin_role, parent: :role do
    name 'admin'
  end
end