# frozen_string_literal: true

class Api::Area < ActiveResource::Base
  ORDER = %w(
    country
    province
    municipality
    neighborhood
  )

  self.site = "#{APP_CONFIG[:api_url]}/api/v3"

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
    :has_weather_curves,
    :has_detailed_chemical_industry,
    :has_aggregated_chemical_industry,
    :has_coal_oil_for_heating_built_environment
  ]

  # Represents an optional nested "scaling" attribute within an Api::Area
  class Scaling < ActiveResource::Base
    self.prefix = Api::Area.prefix
    self.site = Api::Area.site
  end

  def self.grouped
    all_by_area_code
      .values
      .select { |d| d.useable }
      .sort_by { |d| ORDER.index(d.group) || ORDER.length + 1 }
      .group_by(&:group)
  end

  def self.find_by_country_memoized(area_code)
    all_by_area_code[area_code]
  end

  def self.code_exists?(area_code)
    all_by_area_code.key?(area_code.to_s)
  end

  def self.all_by_area_code
    Rails.cache.fetch(:api_areas) do
      find(:all, params: { detailed: false })
        .index_by(&:area).with_indifferent_access
    end
  end

  def self.keys
    all_by_area_code.keys
  end

  def use_network_calculations?
    !!attributes[:use_network_calculations]
  end

  def country?
    %w[province municipality neighborhood region].exclude?(group)
  end

  # Public: Gets the largest region to which the area belongs.
  #
  # For example, if this is a municipality in the Netherlands, the base dataset
  # in "nl", so the Netherlands area is returned.
  #
  # Returns an Api::Area.
  def top_level_area
    if try(:base_dataset).present?
      # rubocop:disable Rails/DynamicFindBy
      self.class.find_by_country_memoized(base_dataset)&.top_level_area || self
      # rubocop:enable Rails/DynamicFindBy
    else
      self
    end
  end
end
