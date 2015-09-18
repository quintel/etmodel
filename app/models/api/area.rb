class Api::Area < ActiveResource::Base
  self.site = "#{APP_CONFIG[:api_url]}/api/v3"

  include Api::CommonArea

  # This list of attributes is used in the forms where you can set the
  # area dependencies for an object, such as the input_elements
  #
  DEPENDABLE_ATTRIBUTES = [
    :_always_hidden,
    :has_agriculture,
    :has_buildings,
    :has_climate,
    :has_coastline,
    :has_cold_network,
    :has_employment,
    :has_fce,
    :has_industry,
    :has_lignite,
    :has_merit_order,
    :has_metal,
    :has_mountains,
    :has_old_technologies,
    :has_other,
    :has_solar_csp,
    :use_network_calculations,
    :has_electricity_storage,
    :is_national_scenario,
    :is_local_scenario
  ]

  def self.find_by_country_memoized(area_code)
    areas = Rails.cache.fetch(:api_areas) do
      all.index_by(&:area).with_indifferent_access
    end

    areas[area_code]
  end

  def use_network_calculations?
    !!attributes[:use_network_calculations]
  end
end
