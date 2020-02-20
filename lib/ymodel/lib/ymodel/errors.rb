# frozen_string_literal: true

# rubocop:disable Style/Documentation
module YModel
  class YModelError < StandardError
  end

  class SourceFileNotFound < YModelError
    attr_reader :model

    def initialize(message = nil, model = nil)
      @model = model

      super(message)
    end
  end

  class MissingConstant < YModelError
  end

  class UnacceptableOptionsError < YModelError
  end
end
# rubocop:enable Style/Documentation
