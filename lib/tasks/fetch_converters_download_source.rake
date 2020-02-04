# frozen_string_literal: true

require 'net/http'
require 'yaml'

desc 'Fetch download links to converters node source analysis from github'
task fetch_converters_download_source: :environment do
  include ConverterDownload

  yml_file = Rails.root.join('config', 'converters_download_source.yml')

  yml = YAML.load_file(yml_file)
  converters = InputElement.all.map(&:related_converter).uniq.reject!(&:blank?)
  converters.each do |converter|
    converter = converter.gsub(/ $/, '')
    ConverterDownload.urls(converter).each do |url|
      yml[converter] = url + '?raw=true' if ConverterDownload.valid_url?(url)
    end
  end
  File.write(yml_file, yml.to_yaml)
end

module ConverterDownload
  def urls(converter)
    git_url = 'https://github.com/quintel/etdataset-public/blob/master/nodes_source_analyses/'
    folder = converter.gsub(/_.*/, '')
    %w[.converter.xlsx .central_producer.xlsx].map do |ending|
      git_url + folder + '/' + converter + ending
    end
  end

  def valid_url?(url)
    parsed_url = URI.parse(url)
    request = Net::HTTP.new(parsed_url.host, parsed_url.port)
    request.use_ssl = true
    response = request.request_head(parsed_url.path)
    return true if response.code == '200'

    false
  end
end
