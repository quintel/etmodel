# frozen_string_literal: true

require 'ymodel/schema'
require 'ymodel/errors'

module YModel
  # Module resposible for loading the schema and data from the yaml files.
  module Loadable

    # This method can be called from within a concrete implementation to
    # overwrite the default ymodel filename associated with that model.
    def source_file(filename)
      @source = filename

      # Similar to YModel::Trigger#inherited. A hook for loading the schema.
      define_readers self
    end

    def schema
      @schema ||= YModel::Schema.new(records)
    rescue Errno::ENOENT
      YModel::Schema.new({})
    end

    protected

    def records
      @records ||= YAML.load_file(source)
        .map(&:symbolize_keys)
    end

    def source
      @source ||= _source
    end

    private

    def _source
      File.join(Rails.root,
                'config',
                'ymodel',
                name.gsub('::', '/').pluralize.underscore + '.yml')
    end
  end
end
