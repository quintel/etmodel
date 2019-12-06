require 'active_support/inflector'

module YModel
  module Relatable
    def belongs_to(model, _options)
      # Defines a getter and a setter
      self.define_method(model) do

      end
    end

    def has_many(model, _options)
      # Defines a getter and pusher
      self.define_method(model) do

      end
    end

    def has_one(model, _options)
      self.define_method(model) do

      end
    end

    private

    def model_class(model)
      Kernel.const_get(model.singularize.camelcase)
    end
  end
end
