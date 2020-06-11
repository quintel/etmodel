# frozen_string_literal: true

require 'yaml'

module YModel
  # This service can be used for dumping models to YAML files.
  module Dump
    DEFAULT_PATH = File.join('config', 'interface')

    def self.call(model, storage_path: DEFAULT_PATH, namespace: Object)
      model       = model.to_s.singularize.camelcase
      model_class = Kernel.const_get(model)
      file_path   = File.join(storage_path,
                              model.underscore.pluralize + '.yml')

      namespace.const_set(model, Class.new(ActiveRecord::Base))

      records =
        model_class.all.map do |record|
          attributes = record.attributes.stringify_keys
          block_given? ? yield(attributes, record) : attributes
        end

      File.write(file_path, records.to_yaml)
    end
  end
end
