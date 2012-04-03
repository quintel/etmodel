class Api::Scenario < ActiveResource::Base
  self.site = APP_CONFIG[:active_resource_base] || APP_CONFIG[:api_url]

  def country
    attributes[:country].present? ? attributes[:country] : region.split("-").first
  end

  def wattnu?
    title && title =~ /Watt Nu/
  end
end
