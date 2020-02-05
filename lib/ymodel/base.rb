# frozen_string_literal: true

require 'ymodel/relatable'
require 'ymodel/loadable'
require 'ymodel/trigger'

module YModel
  # This is used to wrap a YAML file in a similar manner to ActiveRecord wrapping a database.
  class Base
    extend YModel::Relatable
    extend YModel::Loadable
    extend YModel::Trigger

    def initialize(**record)
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

    def attribute?(key)
      schema.include?(key)
    end

    class << self
      def find(id)
        all.find { |record| record.id == id }
      end

      def find_by(attributes)
        sanitized = sanitize_attributes(attributes)
        all.each do |record|
          return record if sanitized.all? { |key, value| record.send(key) == value }
        end
      end

      def find_by_key(key)
        all.find do |record|
          record.key == key.to_s
        end
      end

      def all
        records.map { |record| new(record) }
      rescue Errno::ENOENT
        raise YModel::SourceFileNotFound
      end

      def where(attributes)
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

    private

    def schema
      self.class.schema
    end
  end
end
