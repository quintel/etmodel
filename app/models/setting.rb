##
# Class for all user settings that should persist over a session.
#
class Setting
  extend ActiveModel::Naming

  SCENARIO_ATTRIBUTES = [
    :country,
    :region,
    :end_year,
    :api_session_key
  ]

  DEFAULT_ATTRIBUTES = {
    :show_municipality_introduction => true,
    :hide_unadaptable_sliders       => false,
    :network_parts_affected         => [],
    :track_peak_load                => true,
    :complexity                     => 3,
    :country                        => 'nl',
    :region                         => nil,
    :start_year                     => 2010,
    :end_year                       => 2040
  }

  attr_accessor *DEFAULT_ATTRIBUTES.keys

  attr_accessor :last_etm_controller_name,
                :last_etm_controller_action,
                :displayed_output_element,
                :selected_output_element,
                :scenario_type,
                :scenario_id,
                :api_session_key

  ##
  # @tested 2010-12-06 seb
  #
  def initialize(attributes = {}) 
    attributes = self.class.default_attributes.merge(attributes)
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end
  end

  def [](key)
    self.send("#{key}")
  end

  def []=(key, param)
    self.send("#{key}=", param)
  end

  # Create a new setting object for a Api::Scenario.
  # The setting object has no api_session_key, so that backbone
  # initializes a new ETengine session, based on the loaded scenario.
  #
  # param scenario [Api::Scenario]
  # return [Setting] setting object loaded with the country/end_year/etc from scenario
  #
  def self.load_from_scenario(scenario)
    settings = SCENARIO_ATTRIBUTES.inject({}) {|hsh,key| hsh.merge key => scenario.send(key) }
    # By removing api_session_key we force backbone to create a new ApiScenario
    #   based on :scenario_id
    settings.delete(:api_session_key)
    settings[:scenario_id] = scenario.id
    new(settings)
  end

  ##
  # @tested 2010-12-06 seb
  #
  def self.default
    new(default_attributes)
  end

  def self.default_attributes
    DEFAULT_ATTRIBUTES
  end

  ##
  # @tested 2010-12-06 seb
  #
  def reset!
    self.class.default_attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def reset_scenario
    # RD: used self. here otherwise an other settings object was reset
    self.api_session_key = nil
    self.network_parts_affected = []
  end

  ####### Complexities

  LEVELS = {
    1 => 'simple',
    2 => 'medium',
    3 => 'advanced',
    4 => 'municipalities',
    5 => 'watt_nu',
    6 => 'new_municipality_view',
    7 => 'ameland_advanced',
    8 => 'network'
  }


  ##
  # @untested 2011-01-24 robbert
  # 
  def all_levels
    LEVELS
  end

  ##
  # @tested 2010-11-30 seb
  # 
  def complexity=(param)
    @complexity = param.andand.to_i
  end


  ##
  # @untested 2011-01-09 seb
  # 
  def complexity_key
    LEVELS[self.complexity.to_i]
  end

  ##
  # @tested 2010-11-30 seb
  # 
  def simple?;    self.complexity == 1; end
  def medium?;    self.complexity == 2; end
  def advanced?;  self.complexity == 3; end

  ####### Years

  def end_year=(end_year)
    @end_year = end_year.to_i
  end

  ####### Peak load

  def track_peak_load?
    use_peak_load && track_peak_load
  end

  def use_peak_load
    advanced? && use_network_calculations?
  end

  def use_network_calculations?
    area.try(:use_network_calculations)
  end

  ####### Area / Region

  attr_writer :area

  def set_country_and_region_from_param(param)
    country = param.split("-").first
    set_country_and_region(country, param)
  end

  ##
  # @tested 2010-11-30 seb
  # 
  def set_country_and_region(country, region)
    self.country = country
    self.region = if region.blank? then nil
      elsif region.is_a?(Hash) 
        if region.has_key?(country) 
          region[country]  # You may want to set the province here and override country settings (maybe add a country prefix?)
        else 
          nil
        end
      else region
    end
  end

  def municipality?
    area.try(:is_municipality?)
  end

  def region_or_country
    region || country
  end

  def area_region
    Api::Area.find_by_country(region)
  end

  ##
  # Do not memoize area in setting, because it gets stored in session and 
  # backbone settings.
  #
  # @tested 2010-11-30 seb
  # 
  def area
    Api::Area.find_by_country_memoized(region_or_country)
  end

  ##
  # @tested 2010-12-06 seb
  #
  def area_country
    Api::Area.find_by_country_memoized(country)
  end

  def current_view
    all_levels[complexity.to_i]
  end

  def new_settings_hash
    {
      :country  => country,
      :region   => region,
      :end_year => end_year
    }
  end
end