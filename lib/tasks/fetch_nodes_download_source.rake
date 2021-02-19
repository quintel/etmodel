# frozen_string_literal: true

require 'net/http'
require 'yaml'

desc 'Fetch download links to nodes node source analysis from github'
task fetch_nodes_download_source: :environment do
  include NodeDownload

  yml_file = Rails.root.join('config', 'nodes_download_source.yml')

  yml = YAML.load_file(yml_file) || {}
  nodes = InputElement.all.map(&:related_node).uniq.reject!(&:blank?)

  counter = { total: nodes.length, done: 0 }
  puts "Updating source download links for #{counter[:total]} nodes"
  nodes.each do |node|
    node = node.gsub(/ $/, '')
    NodeDownload.urls(node).each do |url|
      yml[node] = url + '?raw=true' if NodeDownload.valid_url?(url)
    end

    counter[:done] += 1
    puts "(#{counter[:done]} / #{counter[:total]}) processed" if (counter[:done] % 25).zero?
  end
  File.write(yml_file, yml.to_yaml)
  puts 'Done!'
end

module NodeDownload
  # Possible valid file endings
  FILE_ENDINGS = %w[.xlsx .node.xlsx .central_producer.xlsx .converter.xlsx].freeze

  def urls(node)
    git_url = 'https://github.com/quintel/etdataset-public/blob/master/nodes_source_analyses/'
    folder = node.gsub(/_.*/, '')
    FILE_ENDINGS.flat_map do |ending|
      %w[energy molecules].map do |type|
        git_url + type + '/' + folder + '/' + node + ending
      end
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
