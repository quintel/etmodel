# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# If config.yml defines rack_proxy_url then we enable a local rack-based proxy
# In production the proxying is handled directly by nginx
# 
if proxy_url = APP_CONFIG[:rack_proxy_url]
  require 'lib/rack_proxy'

  use Rack::Proxy do |req|
    if req.path =~ Regexp.new(proxy_url)
      remote_url = APP_CONFIG[:rack_remote_url] + req.path.gsub(proxy_url, '')
      URI.parse("#{remote_url}#{"?" if req.query_string}#{req.query_string}")
    end
  end
end

run Etm::Application
