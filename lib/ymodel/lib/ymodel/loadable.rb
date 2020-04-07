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

    def load_records!
      all = records.map { |record| new(record) }
      unless all.map(&:index) == all.map(&:index).uniq
        raise YModel::DuplicateIndexError, 'Some records share the same index.'
      end

      all
    end

    def index_on(key)
      @index = key
    end

    def index
      @index || :id
    end

    protected

    # I dislike the format of this method a lot. Rubocop made me do it..
    def records
      @records ||=
        if compiled?
          Dir.glob(File.join(source, '*.yml'))
            .flat_map { |name| YAML.load_file(name) }
        else
          YAML.load_file(source)
            .map(&:symbolize_keys)
        end
    end

    def source
      @source ||= _source
    end

    private

    def compiled?
      File.directory?(File.join(Rails.root, source))
    end

    def _source
      File.join(Rails.root,
                'config',
                'ymodel',
                name.gsub('::', '/').pluralize.underscore + '.yml')
    end
  end
end
