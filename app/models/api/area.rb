class Api::Area < ActiveResource::Base
  self.site = APP_CONFIG[:active_resource_base] || APP_CONFIG[:api_url]
  self.format = :xml

  # This list of attributes is used in the forms where you can set the
  # area dependencies for an object, such as the input_elements
  #
  DEPENDABLE_ATTRIBUTES = [
    :has_mountains,
    :has_coastlines,
    :use_network_calculations,
    :has_buildings,
    :has_agriculture,
    :has_lignite,
    :has_solar_csp,
    :has_old_technologies,
    :has_cold_network,
    :has_heat_import,
    :has_industry,
    :has_other,
    :has_fce,
    :has_employment
  ]

  def self.find_by_country_memoized(region_or_country)
    @areas_by_country ||= {}.with_indifferent_access
    @areas_by_country[region_or_country] ||= self.find_by_country(region_or_country)
  end

  def self.find_by_country(country)
    find country
  end

  def number_of_existing_households
    number_households * (1 - (percentage_of_new_houses/100))
  end
end
