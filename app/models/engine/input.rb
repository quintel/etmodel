# frozen_string_literal: true

module Engine
  class Input < Dry::Struct
    transform_keys(&:to_sym)

    attribute  :key,              Dry::Types['strict.string']
    attribute  :min,              Dry::Types['nominal.float'] | Dry::Types['nominal.nil']
    attribute  :max,              Dry::Types['nominal.float'] | Dry::Types['nominal.nil']
    attribute  :default,          Dry::Types['nominal.float'] | Dry::Types['nominal.string'] | Dry::Types['nominal.nil']
    attribute  :unit,             Dry::Types['nominal.string'] | Dry::Types['nominal.nil']
    attribute? :disabled,         Dry::Types['nominal.bool'] | Dry::Types['nominal.nil']
    attribute? :coupling_groups,  Dry::Types['nominal.bool'] | Dry::Types['nominal.nil']
  end
end
