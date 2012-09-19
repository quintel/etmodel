##
# Class for all user settings that should persist over a session.
#
class Setting
  extend ActiveModel::Naming

  attr_accessor :last_etm_page,
                :preset_scenario_id,
                :api_session_id,
                :area_code,
                :charts

  def initialize(attributes = {})
    attributes = self.class.default_attributes.merge(attributes)
    attributes.each do |name, value|
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
      :area_code => scenario.area_code
    }
    new(attrs)
  end

  # ------ Defaults and Resetting ---------------------------------------------

  def self.default
    new(default_attributes)
  end

  def self.default_attributes
    charts = {}
    0.upto(3).each do |i|
      charts["chart_#{i}"] = {
        'chart_id' => nil, 'format' => nil, 'default' => nil, 'index' => i}
    end

    {
      :hide_unadaptable_sliders => false,
      :network_parts_affected   => [],
      :track_peak_load          => false,
      :area_code                => 'nl',
      :start_year               => 2010,
      :end_year                 => 2050,
      :use_fce                  => false,
      :already_shown            => [],
      :charts                   => charts
    }
  end
  attr_accessor *default_attributes.keys

  def reset_attribute(key)
    default_value = self.class.default_attributes[key.to_sym]
    self.send("#{key}=", default_value)
  end

  def reset!
    self.class.default_attributes.each do |key, value|
      self.reset_attribute key
    end
  end

  # When a user resets a scenario to its start value
  #
  def reset_scenario
    self.api_session_id = nil
    self.preset_scenario_id = nil # to go back to a blank slate scenario

    [:use_fce, :network_parts_affected, :already_shown, :charts].each do |key|
      self.reset_attribute key
    end
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

  def allow_fce?
    area.attributes[:has_fce]
  end

  # Returns the ActiveResource object
  def area
    Api::Area.find_by_country_memoized(area_code)
  end

  # returns the country part of the area_code
  # nl     => nl
  # nl-bar => nl
  def country
    return nil unless area_code
    area_code.split('-')[0]
  end
end
