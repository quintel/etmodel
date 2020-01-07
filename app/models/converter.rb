# frozen_string_literal: true

# Wraps the urls that point to the node source analysis .xls files on
# github.com/quintel/etdataset-public/node_source_analyses for converters

module Converter
  ALL = YAML.load_file('config/converters_download_source.yml')

  def self.find(name)
    ALL[name]
  end
end
