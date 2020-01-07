module Converter
  ALL = YAML::load_file('config/converters_download_source.yml')

  def self.find(name)
    ALL[name]
  end
end
