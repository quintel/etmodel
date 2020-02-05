# frozen_string_literal: true

module YModel
  # Represents a schema of all keys found in the source.
  class Schema
    def initialize(source)
      @source = source
    end

    def attributes
      @source.flat_map(&:keys)
        .uniq
        .map(&:to_sym)
    end

    # Make this a delegator
    def include?(args)
      attributes.include?(args)
    end
  end
end
