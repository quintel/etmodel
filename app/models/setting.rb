# frozen_string_literal: true

# Class for all user settings that should persist over a session.
#
# A word about locked charts:
# To preserve state across requests and page reloads I save the locked charts
# in a hash made like this:
#
# {'holder_0' => '25', 'holder_1' => '12-T'}
#
# The "T" means that the chart must be shown as a table. The previous
# implementation was using a nested hash but it was a pain to maintain and
# Rails had crazy issues saving the object in memcached-based sessions.
class Setting
  extend ActiveModel::Naming

  MIN_YEAR = 2013
  DEFAULT_YEAR = 2050
  MAX_YEAR = 2050

  # A list of all attributes which may be stored in the Setting, and their
  # default values.
  def self.default_attributes
    {
      network_parts_affected:   [],
      area_code:                'nl',
      start_year:               2011,
      end_year:                 2050,
      use_fce:                  false,
      use_merit_order:          true,
      esdl_exportable:          false,
      locked_charts:            [],
      last_etm_page:            nil,
      preset_scenario_id:       nil,
      api_session_id:           nil,
      active_saved_scenario_id: nil,
      active_scenario_title:    nil,
    }
  end

  attr_accessor(*default_attributes.keys)

  # Public: Create a new setting object for a Api::Scenario.
  #
  # The setting object has no api_session_id, so that backbone initializes a new
  # ETengine session, based on the loaded scenario.
  #
  # scenario                 - The Api::Scenario being loaded.
  # active_saved_scenario    - Optional hash containing the ID and title of the
  #                            currently-active saved scenario.
  #
  # Returns the Setting object loaded with the country, end year, etc, from the
  # scenario.
  def self.load_from_scenario(scenario, active_saved_scenario: {})
    new(
      preset_scenario_id: scenario.id,
      use_fce: scenario.use_fce,
      esdl_exportable: scenario.esdl_exportable,
      end_year: scenario.end_year,
      area_code: scenario.area_code,
      active_saved_scenario_id: active_saved_scenario[:id],
      active_scenario_title: active_saved_scenario[:title]
    )
  end

  def self.default
    new(default_attributes)
  end

  def initialize(attributes = {})
    self.class.default_attributes.merge(attributes).each do |name, value|
      send("#{name}=", value)
    end
  end

  def [](key)
    send(key.to_s)
  end

  def []=(key, param)
    send("#{key}=", param)
  end

  def reset_attribute(key)
    send("#{key}=", self.class.default_attributes[key.to_sym])
  end

  def reset!
    self.class.default_attributes.keys.each { |key| reset_attribute(key) }
  end

  # When a user resets a scenario to its start value
  #
  def reset_scenario
    self.api_session_id = nil
    self.preset_scenario_id = nil # to go back to a blank slate scenario

    %i[use_fce network_parts_affected locked_charts].each do |key|
      reset_attribute(key)
    end
  end

  def start_year
    area.analysis_year || self.class.default_attributes[:start_year]
  end

  def end_year=(end_year)
    @end_year = end_year.to_i
  end

  def use_network_calculations?
    area.try(:use_network_calculations?)
  end

  def allow_merit_order?
    area.attributes[:has_merit_order]
  end

  def allow_fce?
    area.attributes[:has_fce]
  end

  def locked_charts
    @locked_charts || []
  end

  def derived_dataset?
    area&.derived?
  end

  def active_scenario?
    # rubocop:disable Rails/DynamicFindBy
    api_session_id.present? &&
      area_code.present? &&
      Api::Area.find_by_country_memoized(area_code).present?
    # rubocop:enable Rails/DynamicFindBy
  end

  # Returns the ActiveResource object
  def area
    Api::Area.find_by_country_memoized(area_code)
  end

  # returns the country part of the area_code
  # nl     => nl
  # nl-bar => nl
  def country
    area_code.split('-')[0] if area_code
  end

  # Returns the Setting as a Hash (which can then be converted to JSON in a
  # view).
  def to_hash
    hash = self.class.default_attributes.keys.each_with_object({}) do |key, data|
      data[key] = public_send(key)
    end

    hash[:api_session_id] = nil unless active_scenario?
    hash
  end
end
