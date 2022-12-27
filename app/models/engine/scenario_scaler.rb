# frozen_string_literal: true

module Engine
  class ScenarioScaler < Dry::Struct
    transform_keys(&:to_sym)

    attribute :area_attribute,  Dry::Types['strict.string']
    attribute :value,           Dry::Types['coercible.float']
    attribute :base_value,      Dry::Types['coercible.float']
    attribute :has_agriculture, Dry::Types['strict.bool']
    attribute :has_industry,    Dry::Types['strict.bool']
    attribute :has_energy,      Dry::Types['strict.bool']
  end
end
