module YModel
  class Schema
    def initialize(source)
      @source = source
    end

    def attributes
      @source.flat_map(&:keys)
             .uniq
             .map(&:to_sym)
    end
  end
end
