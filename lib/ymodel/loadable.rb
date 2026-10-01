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

    # With is used as the default value of the attribute
    def default_attribute(attr_name, with: nil)
      @schema << attr_name
      define_reader attr_name, default: with
    end

    def schema
      @schema ||= YModel::Schema.new(records)
    rescue Errno::ENOENT
      YModel::Schema.new({})
    end

    def load_records!
      all = records.map { |record| new(record) }
      unless all.map(&:index) == all.map(&:index).uniq
        raise YModel::DuplicateIndexError,
              "#{name}: Some records share the same index"
      end

      all
    end

    def index_on(key)
      @index = key
    end

    def index
      @index || :id
    end

    def source_files
      if compiled?
        Dir.glob(File.join(source, '*.yml'))
      else
        [@source]
      end
    end

    def define_reader(attribute, default: nil)
      define_method(attribute.to_sym) do
        value = instance_variable_get("@#{attribute}")

        if value.nil? && !default.nil?
          value = instance_variable_set(
            "@#{attribute}",
            default.respond_to?(:call) ? default.call : default
          )
        end

        value
      end
    end

    protected

    def records
      @records ||= source_files.flat_map { |name| YAML.load_file(name) }
        .map(&:symbolize_keys)
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
