class Api::Gquery < ActiveResource::Base
  self.site = APP_CONFIG[:api_url]

  # all only returns id,key for now
end