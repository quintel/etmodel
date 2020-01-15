module YModel

  class YModelError < StandardError
  end

  class RecordNotFound < YModelError
    attr_reader :model, :primary_key, :id

    def initialize(message = nil, model = nil, primary_key = nil, id = nil)
      @primary_key = primary_key
      @model = model
      @id = id

      super(message)
    end
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
