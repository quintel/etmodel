# frozen_string_literal: true

module Engine
  class User < Dry::Struct
    transform_keys(&:to_sym)

    attribute :id,   Dry::Types['strict.integer']
    attribute :name, Dry::Types['strict.string']
  end
end
