require 'httparty'

# This is a minimal proxy object used by VCR and caybara-webkit tests. To
# capture http requests VCR monkey-patches net/http, so we pipe the API calls
# through this proxy (see api_proxy_controller.rb).
# Future releases of VCR should include a custom proxy, so in future we should
# be able to drop all of this.
#
# When available the JS app will use CORS, so to make sure the proxy is being
# used set to `true` the `disable_cors` parameter in `config.yml`.
#
class NastyProxy
  include HTTParty
  base_uri Settings.ete_url
end
