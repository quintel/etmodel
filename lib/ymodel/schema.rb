module YModel
  class Schema
    # Takes an array of hashes as input, please parse before we come here!
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
