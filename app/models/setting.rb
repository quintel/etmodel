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
#
class Setting
  extend ActiveModel::Naming

  # A list of all attributes which may be stored in the Setting, and their
  # default values.
  def self.default_attributes
    {
      network_parts_affected: [],
      track_peak_load:        false,
      area_code:              'nl',
      start_year:             2011,
      end_year:               2050,
      use_fce:                false,
      use_merit_order:        false,
      locked_charts:          {},
      last_etm_page:          nil,
      scaling:                nil,
      area_scaling:           nil,
      preset_scenario_id:     nil,
      api_session_id:         nil
    }
  end

  attr_accessor *default_attributes.keys

  def initialize(attributes = {})
    self.class.default_attributes.merge(attributes).each do |name, value|
      self.send("#{name}=", value)
    end
  end

  def [](key)
    send("#{key}")
  end

  def []=(key, param)
    send("#{key}=", param)
  end

  # Create a new setting object for a Api::Scenario.
  # The setting object has no api_session_id, so that backbone
  # initializes a new ETengine session, based on the loaded scenario.
  #
  # param scenario [Api::Scenario]
  # return [Setting] setting object loaded with the country/end_year/etc from scenario
  #
  def self.load_from_scenario(scenario)
    attrs = {
      :preset_scenario_id => scenario.id,
      :use_fce => scenario.use_fce,
      :end_year => scenario.end_year,
      :area_code => scenario.area_code,
      :scaling => scenario.scaling && scenario.scaling.attributes
    }
    new(attrs)
  end

  # ------ Defaults and Resetting ---------------------------------------------

  def self.default
    new(default_attributes)
  end


  def reset_attribute(key)
    self.send("#{key}=", self.class.default_attributes[key.to_sym])
  end

  def reset!
    self.class.default_attributes.keys.each { |key| reset_attribute(key) }
  end

  # When a user resets a scenario to its start value
  #
  def reset_scenario
    self.api_session_id = nil
    self.preset_scenario_id = nil # to go back to a blank slate scenario

    [:use_fce, :network_parts_affected, :locked_charts].each do |key|
      self.reset_attribute key
    end
  end

  def start_year
    area.analysis_year || self.class.default_attributes[:start_year]
  end

  def end_year=(end_year)
    @end_year = end_year.to_i
  end

  def track_peak_load?
    use_peak_load && track_peak_load
  end

  def use_peak_load
    use_network_calculations?
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

  def locked_charts=(charts)
    if charts.respond_to?(:to_h)
      @locked_charts = charts.to_h.transform_values(&:to_s)
    end
  end

  def derived_dataset?
    area.derived?
  end

  # Returns the ActiveResource object
  def area
    @area = if scaling.present?
      Api::ScaledArea.new(Api::Area.find_by_country_memoized(area_code))
    else
      Api::Area.find_by_country_memoized(area_code)
    end
  end

  # returns the country part of the area_code
  # nl     => nl
  # nl-bar => nl
  def country
    return nil unless area_code
    area_code.split('-')[0]
  end

  # Returns the Setting as a Hash (which can then be converted to JSON in a
  # view).
  def to_hash
    self.class.default_attributes.keys.each_with_object({}) do |key, data|
      data[key] = public_send(key)
    end
  end
end
