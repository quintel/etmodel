# frozen_string_literal: true

require 'yaml'

module YModel
  # This service can be used for dumping models to YAML files.
  # Example:
  #
  # def migrate_sidebar_items
  #   # Monkeypatch The class to be dumped if its already a YModel class.
  #   class SidebarItem < ActiveRecord::Base; end
  #
  #   require 'ymodel/dump'
  #   YModel::Dump.('sidebar_items')
  # end
  module Dump
    DEFAULT_PATH = File.join('config', 'ymodel')

    def self.call(model, storage_path = DEFAULT_PATH)
      model = Kernel.const_get(model.to_s.singularize.camelcase)
      file_path = File.join(storage_path,
                            model.name.underscore.pluralize + '.yml')

      File.write(file_path, model.all.map(&:attributes).to_yaml)
    end
  end
end
