class Api::Scenario < ActiveResource::Base
  self.site = APP_CONFIG[:api_url]
end