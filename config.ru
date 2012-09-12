# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)

# If config.yml defines local_proxy then we enable a local rack-based proxy
# In production the proxying is handled directly by nginx.
#
if APP_CONFIG[:local_proxy]
  require 'rack/reverse_proxy'

  proxy_url = APP_CONFIG[:api_proxy_url]

  use Rack::ReverseProxy do |req|
    reverse_proxy Regexp.new("^#{proxy_url}(\/.*)$"), "#{APP_CONFIG[:api_url]}$1"
  end
end

run Etm::Application
