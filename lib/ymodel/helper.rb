# frozen_string_literal: true

module YModel
  # This module contains YModel logic for managing relations.
  module Helper
    def self.model_class(model)
      as_const = model.to_s.singularize.camelcase
      Kernel.const_get(as_const)
    rescue StandardError
      message = "relation `#{model}` couldn't be made because constant "\
                "`#{as_const}` doesn't exist."
      raise YModel::MissingConstant, message
    end
  end
end
