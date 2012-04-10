# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)

# If config.yml defines local_proxy then we enable a local rack-based proxy
# In production the proxying is handled directly by nginx.
# 
if APP_CONFIG[:local_proxy] 
  require "#{Rails.root}/lib/rack_proxy"
  proxy_url = APP_CONFIG[:api_proxy_url]

  use Rack::Proxy do |req|
    # TODO: check robustness of the regexp
    if req.path =~ Regexp.new(proxy_url)
      remote_url = APP_CONFIG[:api_url] + req.path.gsub(proxy_url, '')
      URI.parse("#{remote_url}#{"?" if req.query_string}#{req.query_string}")
    end
  end
end

run Etm::Application
