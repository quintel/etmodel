require 'ymodel/relatable'
require 'ymodel/loadable'
require 'ymodel/trigger'

# YModel is a ActiveRecord like interface to wrap YAML.
module YModel
  class Base
    extend YModel::Relatable
    extend YModel::Loadable
    extend YModel::Trigger

    def initialize(record: {})
      record.each do |k, v|
        instance_variable_set '@' + k, v
      end
    end

    class << self
      def find(id)
        all.find { |record| record.id == id }
      end

      def find_by_key(key)
        all.find do |record|
          record.key == key.to_s
        end
      end

      def all
        records.map { |record| new(record: record) }
      rescue Errno::ENOENT
        raise YModel::SourceFileNotFound
      end

      def where(options)
        # all.select do |rec|
        #   options.all{ |key, val| rec.instance_variable_get('@' + key) == val }
        # end
      end
    end
  end
end
