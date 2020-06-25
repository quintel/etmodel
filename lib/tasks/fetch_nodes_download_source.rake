# frozen_string_literal: true

require 'net/http'
require 'yaml'

desc 'Fetch download links to nodes node source analysis from github'
task fetch_nodes_download_source: :environment do
  include NodeDownload

  yml_file = Rails.root.join('config', 'nodes_download_source.yml')

  yml = YAML.load_file(yml_file)
  nodes = InputElement.all.map(&:related_node).uniq.reject!(&:blank?)
  nodes.each do |node|
    node = node.gsub(/ $/, '')
    NodeDownload.urls(node).each do |url|
      yml[node] = url + '?raw=true' if NodeDownload.valid_url?(url)
    end
  end
  File.write(yml_file, yml.to_yaml)
end

module NodeDownload
  def urls(node)
    git_url = 'https://github.com/quintel/etdataset-public/blob/master/nodes_source_analyses/'
    folder = node.gsub(/_.*/, '')
    %w[.node.xlsx .central_producer.xlsx].map do |ending|
      git_url + folder + '/' + node + ending
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
