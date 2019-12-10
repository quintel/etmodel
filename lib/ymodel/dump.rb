require 'yaml'

module YModel
  # This service can be used for dumping models to yaml files.
  module Dump
    def self.call(model, storage_path=File.join(Rails.root,'config','ymodel'))
      model = Kernel.const_get(model.to_s.singularize.camelcase)
      file_path  = File.join(storage_path, model.name.underscore + ".yml")

      File.write(file_path, model.all.map(&:attributes).to_yaml )
    end
  end
end
