# frozen_string_literal: true

module Engine
  class Query < Dry::Struct
    transform_keys(&:to_sym)

    attribute :key,     Dry::Types['coercible.string']
    attribute :present, Dry::Types['coercible.float']
    attribute :future,  Dry::Types['coercible.float']
    attribute :unit,    Dry::Types['coercible.string']
  end
end
