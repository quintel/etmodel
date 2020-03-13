# frozen_string_literal: true

require 'active_support/inflector'
require 'ymodel/errors'
require 'ymodel/helper'

module YModel
  # This module contains YModel logic for managing relations.
  module Relatable
    # This method is used to define the key on which relations are build.
    # We default to 'id'.
    def index_on(key)
      @index = key
    end

    def index
      @index || :id
    end

    def belongs_to(model, options = {})
      define_method(model) do
        # We might want to create a mechanism to memoize this.
        related_class =
          options[:class_name] || YModel::Helper.model_class(model)
        key =
          if related_class < YModel::Base
            :"#{model.to_s.singularize}_#{related_class.index}"
          else
            :"#{related_class.to_s.singularize}_id"
          end
        related_class.find(self[key])
      end
    end

    # These cop is disabled because its  a copy of ActiveRecords interface
    # rubocop:disable Naming/PredicateName
    # rubocop:disable Naming/UncommunicativeMethodParamName
    def has_many(model, class_name: nil, as: nil, foreign_key: nil)
      raise_options_error if as && foreign_key

      foreign_key ||= default_foreign_key
      define_method(model) do
        relation_class = YModel::Helper.model_class(class_name || model)
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
      define_method(model) do
        relation_class = YModel::Helper.model_class(class_name || model)
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

    def raise_options_error
      raise YModel::UnacceptableOptionsError, "Relations with an 'as' and"\
          " 'foreign_key' are not supported."
    end
  end
end
