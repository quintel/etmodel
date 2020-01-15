require 'active_support/inflector'
require 'ymodel/errors'
# This module contains YModel logic for managin relations. Some caveats:
# - combining as and foreign_key won't work
# - the default foreign_key won't contain namespaces.

module YModel
  module Relatable
    def belongs_to(model, _options={})
      self.define_method(model) do
        foreign_key = model.to_s.singularize + '_id'
        relation_class.find(instance_variable_get(foreign_key))
      end
    end

    def has_many(model, class_name: nil, as: nil, foreign_key: nil, **options)
      raise_options_error if as && foreign_key

      foreign_key   ||= default_foreign_key
      relation_class  = model_class(class_name || model)
      klass_name      = klass_name
      self.define_method(model) do
        if as
          relation_class.where( "#{as}_id"   => self.id,
                                "#{as}_type" => klass_name)
        else
          relation_class.where(foreign_key.to_sym => self.id)
        end
      end
    end

    def has_one(model, class_name: nil, as: nil, foreign_key: nil, **options)
      raise_options_error if as && foreign_key

      foreign_key   ||= default_foreign_key
      relation_class  = model_class(class_name || model)
      klass_name      = klass_name

      self.define_method(model) do
        if as
          relation_class.find_by( "#{as}_id"   => self.id,
                                  "#{as}_type" => klass_name)
        else
          relation_class.find_by(foreign_key => self.id)
        end
      end
    end

    def default_foreign_key
      klass_name.underscore
                .split('/')
                .last
                .+('_id')
                .to_sym
    end

    private

    def model_class(model)
      Kernel.const_get(model.to_s.singularize.camelcase)
    rescue
      message = "relation `#{model.to_s}` couldn't be made because constant "\
                "`#{model.to_s.singularize.camelcase}` doesn't exist."
      raise YModel::MissingConstant.new(message)
    end

    def klass_name
      self.name
    end

    def raise_options_error
        raise YModel::UnacceptableOptionsError.new("Relations with an 'as' and"\
          " 'foreign_key' are not supported.")
    end
  end
end
