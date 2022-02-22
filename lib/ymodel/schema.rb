# frozen_string_literal: true

require 'forwardable'

module YModel
  # Represents a schema of all keys found in the source.
  class Schema
    extend Forwardable
    include Enumerable
    attr_reader :attributes
    def_delegators :attributes, :each

    def initialize(source)
      @attributes = source.flat_map(&:keys)
        .map(&:to_sym)
        .to_set
    end

    def include?(key)
      attributes.include?(key.to_sym)
    end

    def <<(attribute)
      @attributes << attribute.to_sym
    end
  end
end
