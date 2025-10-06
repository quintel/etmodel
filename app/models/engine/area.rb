# frozen_string_literal: true

class Engine::Area < ActiveResource::Base
  ORDER = %w(
    country
    province
    province_vanuatu
    municipality_dk
    municipality_be
    municipality
    neighborhood
    neighbourhood_be
  )

  self.site = "#{Settings.ete_url}/api/v3"

  # This list of attributes is used in the forms where you can set the
  # area dependencies for an object, such as the input_elements
  #
  DEPENDABLE_ATTRIBUTES = [
    :_always_hidden,
    :has_agriculture,
    :has_climate,
    :has_coastline,
    :has_industry,
    :has_lignite,
    :has_merit_order,
    :has_mountains,
    :has_solar_csp,
    :has_weather_curves,
    :has_coal_oil_for_heating_built_environment
  ]

  # Represents an optional nested "scaling" attribute within an Engine::Scenario
  class Scaling < ActiveResource::Base
    self.prefix = Engine::Area.prefix
    self.site = Engine::Area.site
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


  def country?
    %w[province province_vanuatu municipality_dk municipality_be municipality neighborhood neighbourhood_be region res].exclude?(group)
  end

  # Public: Gets the country to which the area belongs.
  #
  # If the area is a country, self is returned. Otherwise iteratively looks at the parent datasets
  # until it finds a country. If none is found, self is returned.
  def country_area
    if country? || try(:base_dataset).blank?
      self
    else
      # Remove a trailing year from the dataset key.
      base_key = base_dataset.gsub(/\d{4}$/, '')

      self.class.find_by_country_memoized(base_key).country_area || self
    end
  end

  #  Public: Gets the largest region to which the area belongs.
  #
  # For example, if this is a municipality in the Netherlands, the base dataset
  # in "nl", so the Netherlands area is returned.
  #
  # Returns an Engine::Scenario.
  def top_level_area
    if try(:base_dataset).present?
      # Remove a trailing year from the dataset key.
      base_key = base_dataset.gsub(/\d{4}$/, '')

      # rubocop:disable Rails/DynamicFindBy
      self.class.find_by_country_memoized(base_key)&.top_level_area || self
      # rubocop:enable Rails/DynamicFindBy
    else
      self
    end
  end
end
