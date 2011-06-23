class Api::Input < ActiveResource::Base
  self.site = APP_CONFIG[:api_url]
end