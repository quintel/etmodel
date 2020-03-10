# frozen_string_literal: true

require 'active_support/inflector'
require 'ymodel/errors'

module YModel
  # This module contains YModel logic for managing relations. Some caveats:
  #   - combining the 'as' and 'foreign_key' options won't work.
  #   - the default foreign_key won't contain namespaces.
  #   - Seems to be the most smelly piece of code in YModel.
  module Relatable
    def belongs_to(model, options = {})
      related_class = options[:class_name] || model_class(model)
      define_method(model) do
        if related_class < YModel::Base
          key = :"#{model.to_s.singularize}_#{related_class.index}"
        else
          key = :"#{related_class.to_s.singularize}_id"
        end
        related_class.find(self[key])
      end
    end

    # These cop is disabled because Its just a copy of ActiveRecords interface
    # rubocop:disable Naming/PredicateName
    # rubocop:disable Naming/UncommunicativeMethodParamName
    def has_many(model, class_name: nil, as: nil, foreign_key: nil)
      raise_options_error if as && foreign_key

      foreign_key ||= default_foreign_key
      relation_class = model_class(class_name || model)

      define_method(model) do
        if as
          relation_class.where("#{as}_id" => id,
                               "#{as}_type" => self.class.name)
        else
          relation_class.where(foreign_key.to_sym => index)
        end
      end
    end

    def has_one(model, class_name: nil, as: nil, foreign_key: nil)
      raise_options_error if as && foreign_key

      foreign_key ||= default_foreign_key
      relation_class = model_class(class_name || model)

      define_method(model) do
        return relation_class.find_by(foreign_key => index) unless as

        relation_class.find_by("#{as}_id" => id,
                               "#{as}_type" => self.class.name)
      end
    end
    # rubocop:enable Naming/PredicateName
    # rubocop:enable Naming/UncommunicativeMethodParamName

    private

    def default_foreign_key
      name.foreign_key
    end

    def model_class(model)
      as_const = model.to_s.singularize.camelcase
      Kernel.const_get(as_const)
    rescue StandardError
      message = "relation `#{model}` couldn't be made because constant "\
                "`#{as_const}` doesn't exist."
      raise YModel::MissingConstant, message
    end

    def raise_options_error
      raise YModel::UnacceptableOptionsError, "Relations with an 'as' and"\
          " 'foreign_key' are not supported."
    end
  end
end
