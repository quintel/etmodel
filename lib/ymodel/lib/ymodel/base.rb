# frozen_string_literal: true

require 'ymodel/relatable'
require 'ymodel/loadable'
require 'ymodel/trigger'

module YModel
  # This is used to wrap a YAML file in a similar manner to ActiveRecord
  # wrapping a database.
  class Base
    extend YModel::Relatable
    extend YModel::Loadable
    extend YModel::Trigger

    def initialize(record = {})
      record.each do |k, v|
        instance_variable_set "@#{k}".to_s, v if attribute?(k)
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

    class << self
      def find(index)
        all.find { |record| record.index == index }
      end

      def find_by(attributes)
        sanitized = sanitize_attributes(attributes)
        all.each do |record|
          return record if sanitized.all? { |k, v| record.send(k) == v }
        end
        raise RecordNotFoundError, attributes
      end

      def find_by_key(key)
        all.find do |record|
          record.key == key.to_s
        end
      end

      def all
        @all ||= load_records!
      rescue Errno::ENOENT
        raise YModel::SourceFileNotFound
      end

      def where(attributes)
        sanitized = sanitize_attributes(attributes)

        if sanitized.length != attributes.length
          unpermitted = (attributes.keys.map(&:to_sym) - sanitized.keys)
          message = "These attributes are not allowed: #{unpermitted}"

          raise UnpermittedParamsError, message
        end

        all.select do |record|
          sanitized.all? { |key, value| record.send(key) == value }
        end
      end

      # Beware of using this method. If all attributes get removed during
      # sanitation it returns the equivalent of #all.
      def where!(attributes)
        sanitized = sanitize_attributes(attributes)
        all.select do |record|
          sanitized.all? { |key, value| record.send(key) == value }
        end
      end

      def sanitize_attributes(attributes)
        attributes.symbolize_keys!
          .select { |attr| schema.include?(attr) }
      end
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
