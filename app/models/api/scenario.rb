class Api::Scenario < ActiveResource::Base
  self.site = APP_CONFIG[:active_resource_base] || APP_CONFIG[:api_url]
  self.format = :xml

  def wattnu?
    title && title =~ /Watt Nu/
  end
end
