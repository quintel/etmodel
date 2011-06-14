class Api::Scenario < ActiveResource::Base
  self.site = APP_CONFIG[:api_url]

  def country
    region.split("-").first
  end
end