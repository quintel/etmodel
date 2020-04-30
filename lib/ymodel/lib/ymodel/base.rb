# frozen_string_literal: true

require 'ymodel/relatable'
require 'ymodel/loadable'
require 'ymodel/triggerable'
require 'ymodel/queryable'

module YModel
  # This is used to wrap a YAML file in a similar manner to ActiveRecord
  # wrapping a database.
  class Base
    extend YModel::Relatable
    extend YModel::Loadable
    extend YModel::Triggerable
    extend YModel::Queryable

    def initialize(record = {})
      record.each do |k, v|
        instance_variable_set "@#{k}", v if attribute?(k)
      end
    end

    def ==(other)
      attributes == other.attributes
    end

    def attributes
      schema.attributes
        .each_with_object({}) { |attr, memo| memo[attr] = send(attr) }
    end

    def [](property)
      instance_variable_get("@#{property}")
    end

    def attribute?(key)
      schema.include?(key)
    end

    def index
      self[index_key]
    end

    private

    def schema
      self.class.schema
    end

    def index_key
      self.class.instance_variable_get('@index') || :id
    end

    def index_set?
      # The name of the key of the index is stored as an instance variable in
      # the class.
      index = self.class.instance_variable_get('@index') || :id
      self[index]
    end
  end
end
