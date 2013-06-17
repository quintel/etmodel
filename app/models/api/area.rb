class Api::Area < ActiveResource::Base
  self.site = "#{APP_CONFIG[:api_url]}/api/v3"

  # This list of attributes is used in the forms where you can set the
  # area dependencies for an object, such as the input_elements
  #
  DEPENDABLE_ATTRIBUTES = [
    :has_agriculture,
    :has_buildings,
    :has_climate,
    :has_coastline,
    :has_cold_network,
    :has_employment,
    :has_fce,
    :has_heat_import,
    :has_industry,
    :has_lignite,
    :has_merit_order,
    :has_metal,
    :has_mountains,
    :has_old_technologies,
    :has_other,
    :has_solar_csp,
    :use_network_calculations,
    :has_energy_storage
  ]

  def self.find_by_country_memoized(area_code)
    if @areas_by_country.nil?
      @areas_by_country ||= all.each_with_object({}) do |area, store|
        store[area.area] = area
      end.with_indifferent_access
    end

    @areas_by_country[area_code]
  end

  def number_of_existing_households
    number_households * (1 - (percentage_of_new_houses/100))
  end

  def use_network_calculations?
    !!attributes[:use_network_calculations]
  end
end
