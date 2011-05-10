class Api::Scenario < ActiveResource::Base
  self.site = Current.server_config.api_url
end