# frozen_string_literal: true

require 'active_support/inflector'
require 'ymodel/errors'

module YModel
  # This module contains YModel logic for managing relations. Some caveats:
  #   - combining the 'as' and 'foreign_key' options won't work.
  #   - the default foreign_key won't contain namespaces.
  #   - Seems to be the most smelly piece of code in YModel.
  module Relatable
    def belongs_to(model, _options = {})
      define_method(model) do
        foreign_key = model.to_s.singularize + '_id'
        relation_class.find(instance_variable_get(foreign_key))
      end
    end

    # These cop is disabled because I'm just copying ActiveRecords interface
    # rubocop:disable Naming/PredicateName,
    # rubocop:disable Naming/UncommunicativeMethodParamName
    def has_many(model, class_name: nil, as: nil, foreign_key: nil, **_options)
      raise_options_error if as && foreign_key

      foreign_key   ||= default_foreign_key
      relation_class  = model_class(class_name || model)
      klass_name      = klass_name
      define_method(model) do
        if as
          relation_class.where("#{as}_id" => id,
                               "#{as}_type" => klass_name)
        else
          relation_class.where(foreign_key.to_sym => id)
        end
      end
    end

    def has_one(model, class_name: nil, as: nil, foreign_key: nil, **_options)
      raise_options_error if as && foreign_key

      foreign_key   ||= default_foreign_key
      relation_class  = model_class(class_name || model)
      klass_name      = klass_name

      define_method(model) do
        if as
          relation_class.find_by("#{as}_id" => id,
                                 "#{as}_type" => klass_name)
        else
          relation_class.find_by(foreign_key => id)
        end
      end
    end
    # rubocop:enable Naming/PredicateName,
    # rubocop:enable Naming/UncommunicativeMethodParamName

    private

    def default_foreign_key
      klass_name.underscore
        .split('/')
        .last
                .+('_id')
        .to_sym
    end

    def model_class(model)
      Kernel.const_get(model.to_s.singularize.camelcase)
    rescue StandardError
      message = "relation `#{model}` couldn't be made because constant "\
                "`#{model.to_s.singularize.camelcase}` doesn't exist."
      raise YModel::MissingConstant, message
    end

    def klass_name
      name
    end

    def raise_options_error
      raise YModel::UnacceptableOptionsError, "Relations with an 'as' and"\
          " 'foreign_key' are not supported."
    end
  end
end
