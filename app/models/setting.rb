##
# Class for all user settings that should persist over a session.
#
class Setting
  extend ActiveModel::Naming

  SCENARIO_ATTRIBUTES = [
    :country,
    :region,
    :end_year,
    :use_fce
  ]

  # 2011-09 seb: The (empty) arrays in DEFAULT_ATTRIBUTES caused bug. see regression test. 
  # DEFAULT_ATTRIBUTES = {

  LEVELS = {
    1 => 'simple',
    2 => 'medium',
    3 => 'advanced',
    4 => 'municipalities',
    5 => 'watt_nu',
    6 => 'new_municipality_view',
    7 => 'ameland_advanced',
    8 => 'network',
    9 => 'nl_noord'
    
  }.freeze

  attr_accessor :last_etm_controller_name,
                :last_etm_controller_action,
                :displayed_output_element,
                :selected_output_element,
                :scenario_type,
                :scenario_id,
                :api_session_id

  ##
  # @tested 2010-12-06 seb
  #
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
    settings = SCENARIO_ATTRIBUTES.inject({}) {|hsh,key| hsh.merge key => scenario.send(key) }
    # By removing api_session_id we force backbone to create a new ApiScenario
    #   based on :scenario_id
    settings.delete(:api_session_id)
    settings[:scenario_id] = scenario.id
    new(settings)
  end

  # ------ Defaults and Resetting ---------------------------------------------

  # @tested 2010-12-06 seb
  #
  def self.default
    new(default_attributes)
  end

  def self.default_attributes
    {
      :hide_unadaptable_sliders       => false,
      :network_parts_affected         => [],
      :track_peak_load                => true,
      :complexity                     => 3,
      :country                        => 'nl',
      :region                         => nil,
      :start_year                     => 2010,
      :end_year                       => 2040,
      :use_fce                        => false,
      :already_shown                  => []
    }
  end
  attr_accessor *default_attributes.keys

  def new_settings_hash
    {
      :country  => country,
      :region   => region,
      :end_year => end_year,
      :scenario_id => scenario_id,
      :use_fce => use_fce
    }
  end

  def reset_attribute(key)
    default_value = self.class.default_attributes[key.to_sym]
    self.send("#{key}=", default_value)
  end

  # @tested 2010-12-06 seb
  #
  def reset!
    self.class.default_attributes.each do |key, value|
      self.reset_attribute key
    end
  end

  # When a user resets a scenario to it's start value, 
  #
  def reset_scenario
    # RD: used self. here otherwise an other settings object was reset
    self.api_session_id = nil
    self.scenario_id = nil # to go back to a blank slate scenario

    [:use_fce, :network_parts_affected, :already_shown].each do |key|
      self.reset_attribute key
    end
  end

  # ------ Complexities -------------------------------------------------------

  # @untested 2011-01-24 robbert
  # 
  def all_levels
    LEVELS
  end

  def complexity=(param)
    @complexity = param.andand.to_i
  end

  def complexity_key
    LEVELS[self.complexity.to_i]
  end

  def simple?;    self.complexity == 1; end
  def medium?;    self.complexity == 2; end
  def advanced?;  self.complexity == 3; end

  
  # ------ Years --------------------------------------------------------------

  def end_year=(end_year)
    @end_year = end_year.to_i
  end

  # ------ Peak load ----------------------------------------------------------

  def track_peak_load?
    use_peak_load && track_peak_load
  end

  def use_peak_load
    advanced? && use_network_calculations?
  end

  def use_network_calculations?
    area.try(:use_network_calculations)
  end

  # ------ FCE ----------------------------------------------------------------

  def allow_fce?
    advanced? && area.try(:has_fce)
  end

  # ------ Area ---------------------------------------------------------------

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
    area.andand.is_municipality?
  end

  def region_or_country
    region || country
  end

  def area_region
    Api::Area.find_by_country_memoized(region)
  end

  # Do not memoize area in setting, because it gets stored in session and 
  # backbone settings.
  #
  # @tested 2010-11-30 seb
  # 
  def area
    Api::Area.find_by_country_memoized(region_or_country)
  end

  # @tested 2010-12-06 seb
  #
  def area_country
    Api::Area.find_by_country_memoized(country)
  end


  # ------ View ---------------------------------------------------------------

  def current_view
    all_levels[complexity.to_i]
  end

  # Use for pages that should only be shown once to a user.
  # Example Usage in controller:
  #
  #   if Current.setting.already_shown?("demand/intro")
  #     redirect_to :action => 'index'
  #   else 
  #    render :action => 'show'
  #   end
  #
  #
  # @param key [String] key of page, normally the path
  # @param touch [Boolean] save key as shown; default true.
  # @return true if page has been shown once
  # @return false if page hasn't been shown yet
  #
  def already_shown?(key, touch = true)
    if already_shown.include?(key.to_s)
      true
    else
      already_shown << key.to_s if touch
      false
    end
  end
end