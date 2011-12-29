class Api::Input < ActiveResource::Base
  self.site = APP_CONFIG[:active_resource_base] || APP_CONFIG[:api_url]
end