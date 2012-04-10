class Api::Gquery < ActiveResource::Base
  self.site = APP_CONFIG[:active_resource_base] || APP_CONFIG[:api_url]
  self.format = :xml

  # all only returns id,key for now
end
