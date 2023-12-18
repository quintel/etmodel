# frozen_string_literal: true

FactoryBot.define do
  factory :saved_scenario_user do
    role_id { User::ROLES.key(:scenario_owner) }
    user
  end
end
