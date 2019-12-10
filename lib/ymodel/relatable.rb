require 'active_support/inflector'

module YModel
  module Relatable
    def belongs_to(model, _options={})
      self.define_method(model) do
        foreign_key = model.to_s.singularize + '_id'
        relation_class.find(instance_variable_get(foreign_key))
      end
    end

    def has_many(model, options={})
      # These variable declarations are scope related. I can't seem to access
      # the private methods from within the define_method block.
      relation_class, klass = model_class(model), _klass

      self.define_method(model) do
        if options[:as]
          relation_name = options[:as].to_s
          debugger
          relation_class.where(
            relation_name + '_id' => self.id,
            relation_name + '_type' => model.to_s.singularize
          )
        else
          relation_class.where(klass.underscore + "_id" => self.id)
        end
      end
    end

    def has_one(model, options={})
      # These variable declarations are scope related. I can't seem to access
      # the private methods from within the define_method block.
      relation_class, klass = model_class(model), _klass
      self.define_method(model) do
        if options[:as]
            relation_name = options[:as].to_s
            relation_class.find_by(
              relation_name + '_id' => self.id,
              relation_name + '_type' => model.to_s.singularize
            )
        else
            relation_class.where(klass.underscore + "_id" => self.id)
        end
      end
    end

    private

    def model_class(model)
      Kernel.const_get(model.to_s.singularize.camelcase)
    end

    def _klass
      self.name
    end
  end
end
