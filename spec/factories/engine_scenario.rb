# frozen_string_literal: true

FactoryBot.define do
  factory :engine_scenario, class: 'Engine::Scenario' do
    area_code { 'nl' }
    balanced_values { {} }
    end_year { 2050 }
    esdl_exportable { false }
    coupling { false }
    keep_compatible { false }
    metadata { {} }
    owner { { id: 1, name: 'John Doe' } }
    private { false }
    sequence(:id) { |n| n }
    user_values { {} }

    initialize_with do
      Engine::Scenario.new(attributes)
    end
  end
end
