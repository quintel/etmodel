require "ymodel/schema"
require "ymodel/errors"

module YModel
  module Loadable
    def source_file(filename)
      @source = filename

      # Similar to TModel::Trigger#inherited. A hook for loading the schema.
      set_readers self
    end

    def schema
      YModel::Schema.new(records)
    rescue Errno::ENOENT
      YModel::Schema.new({})
    end

    protected

    def records
      @records ||= YAML.load_file(source)
    end

    def source
      @source ||= _source
    end

    private

    def _source
      File.join(Rails.root,
                'config',
                'ymodel',
                self.name.gsub('::', '/').pluralize.downcase + ".yml")

    end
  end
end
