FactoryBot.define do
  factory :general_user_notification do
    key 'foobar'
    notification_en 'EN'
    notification_nl 'NL'
    active true
  end
end
