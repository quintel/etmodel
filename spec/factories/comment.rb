FactoryGirl.define do
  factory :comment do
    association :commentable, factory: :prediction
    title 'Comment title'
    body 'Comment Body'
  end
  
  factory :user_comment, parent: :comment do
    association :user, factory: :user
  end
  
  factory :guest_comment, parent: :comment do
    name 'Tony Manero'
    email 'tony.manero@quintel.com'
  end
end