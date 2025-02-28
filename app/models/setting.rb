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

  MIN_YEAR = 2020
  DEFAULT_YEAR = 2050
  MAX_YEAR = 2070

  # A list of all attributes which may be stored in the Setting, and their
  # default values.
  def self.default_attributes
    {
      network_parts_affected:   [],
      area_code:                'nl2019',
      start_year:               2019,
      end_year:                 2050,
      use_merit_order:          true,
      esdl_exportable:          false,
      coupling:                 false,
      active_couplings:         [],
    inactive_couplings:         [],
      locked_charts:            [],
      last_etm_page:            nil,
      preset_scenario_id:       nil,
      api_session_id:           nil,
      active_saved_scenario_id: nil,
      active_scenario_title:    nil,
    }
  end

  attr_accessor(*default_attributes.keys)

  # Public: Create a new setting object for a Engine::Scenario.
  #
  # The setting object has no api_session_id, so that backbone initializes a new
  # ETengine session, based on the loaded scenario.
  #
  # scenario                 - The Engine::Scenario being loaded.
  # active_saved_scenario    - Optional hash containing the ID and title of the
  #                            currently-active saved scenario.
  #
  # Returns the Setting object loaded with the country, end year, etc, from the
  # scenario.
  def self.load_from_scenario(scenario, active_saved_scenario: {})
    new(
      preset_scenario_id: scenario.id,
      esdl_exportable: scenario.esdl_exportable,
      coupling: scenario.coupled?,
      active_couplings: scenario.active_couplings,
      inactive_couplings: scenario.inactive_couplings,
      end_year: scenario.end_year,
      area_code: scenario.area_code,
      active_saved_scenario_id: active_saved_scenario[:id],
      active_scenario_title: active_saved_scenario[:title] || scenario.title
    )
  end

  def self.default
    new(default_attributes)
  end

  def self.load_with_preset(scenario, preset_id, active_saved_scenario: {})
    setting = load_from_scenario(scenario, active_saved_scenario:)
    setting.preset_scenario_id = preset_id
    setting.api_session_id = scenario.id

    setting
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

    %i[network_parts_affected locked_charts].each do |key|
      reset_attribute(key)
    end
  end

  def uncouple_scenario
    self.coupling = false
  end

  def deactivate_coupling(group)
    active_couplings.delete(group)
    unless inactive_couplings.include?(group)
      inactive_couplings << group
    end
  end

  def activate_coupling(group)
    inactive_couplings.delete(group)
    unless active_couplings.include?(group)
      active_couplings << group
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
      Engine::Area.find_by_country_memoized(area_code).present?
    # rubocop:enable Rails/DynamicFindBy
  end

  # Returns the ActiveResource object
  def area
    Engine::Area.find_by_country_memoized(area_code)
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

  # Updates scenario-related attributes in the Setting
  def update_scenario_session(new_scenario, saved_scenario_id:, title:)
    self.api_session_id = new_scenario.id
    self.active_saved_scenario_id = saved_scenario_id
    self.active_scenario_title = title
  end
end
