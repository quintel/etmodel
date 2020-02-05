# frozen_string_literal: true
require 'forwardable'

module YModel
  # Represents a schema of all keys found in the source.
  class Schema
    extend Forwardable
    include Enumerable

    def_delegators :attributes, :each

    def initialize(source)
      @source = source
    end

    def attributes
      @source.flat_map(&:keys)
        .uniq
        .map(&:to_sym)
    end

    def include?(key)
      attributes.include?(key.to_sym)
    end
  end
end
