class Api::Area < ActiveResource::Base
  self.site = APP_CONFIG[:api_url]
  
  def self.find_by_country_memoized(region_or_country)
    @areas_by_country ||= {}.with_indifferent_access
    @areas_by_country[region_or_country] ||= self.find_by_country(region_or_country)
  end
  
  def self.find_by_country(country)
    first(:params => { :country => country })
  end
    
  def number_of_existing_households
    number_households * (1 - (percentage_of_new_houses/100))
  end  
end
