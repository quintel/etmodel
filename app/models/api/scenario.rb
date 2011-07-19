class Api::Scenario < ActiveResource::Base
  self.site = APP_CONFIG[:api_url]

  def country
    attributes[:country].present? ? attributes[:country] : region.split("-").first
  end
end