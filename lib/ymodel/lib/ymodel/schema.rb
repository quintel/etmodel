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
        .uniq
        .map(&:to_sym)
    end

    def include?(key)
      attributes.include?(key.to_sym)
    end
  end
end
