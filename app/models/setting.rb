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
    :hide_unadaptable_sliders => false,
    :network_parts_affected => [],
    :track_peak_load => true,
    :complexity => 3,
    :country => 'nl',
    :region => nil,
    :start_year => 2010,
    :end_year => 2040
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

  ##
  # @tested 2010-12-06 seb
  #
  def self.default
    new(default_attributes)
  end

  ##
  # @tested 2010-12-06 seb
  #
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
    api_session_key = nil
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

  ##
  # @tested 2010-11-30 seb
  # 
  def years
    end_year - start_year
  end

  ####### Peak load

  ##
  # @tested 2010-12-07 seb
  #
  def track_peak_load?
    use_peak_load and track_peak_load
  end

  ##
  # @tested 2010-11-30 seb
  # 
  def use_peak_load
    advanced? and use_network_calculations?
  end

  ##
  # @tested 2010-11-30 seb
  # 
  def use_network_calculations?
    area.andand.use_network_calculations == true
  end


  ####### Area / Region

  attr_writer :area


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

  ##
  # @tested 2010-11-30 seb
  # 
  def municipality?
    area.andand.is_municipality? == true
  end


  ##
  # @tested 2010-11-30 seb
  # 
  def region_or_country
    region || country
  end

  ##
  # @tested 2010-12-06 seb
  # 
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


  ##
  # @tested 2010-11-30 seb
  # 
  # DEBT: Remove after we have ported house_selection tool
  def number_of_households
    @number_of_households ||= area.andand.number_households
  end

  # DEBT: Remove after we have ported house_selection tool
  def number_of_households=(value)
    @number_of_households = value
  end

  ##
  # @tested 2010-11-30 seb
  # 
  # DEBT: Remove after we have ported house_selection tool
  def number_of_existing_households
    @number_of_existing_households ||= area.andand.number_of_existing_households
  end

  # DEBT: Remove after we have ported house_selection tool
  def number_of_existing_households=(value)
    @number_of_existing_households = value
  end

  def current_view
    all_levels[complexity.to_i]
  end
 
  ##
  # Returns the scale factor for the municipality. Nil if not scaled
  #
  # @param [InputElement] input_element
  # @return [Float, nil] the scale factor or nil if not scaled.
  #
  # @tested 2010-12-06 seb
  #
  # TODO: refactor this or refactor the tests - PZ Wed 27 Apr 2011 15:48:52 CEST
  def scale_factor_for_municipality(input_element)
    return nil unless input_element.locked_for_municipalities
    if input_element_scaled_for_municipality?(input_element)
      electricity_country = area_country.current_electricity_demand_in_mj
      electricity_region  = area_region.current_electricity_demand_in_mj
      electricity_country.to_f / electricity_region rescue nil # prevent division by zero, you never know
    end
  end
 
  ##
  # Does the input_element have to be scaled?
  #
  # @param [InputElement] input_element
  # @return [Boolean]
  #
  # @tested 2010-12-06 seb
  #
  def input_element_scaled_for_municipality?(input_element)
    # TODO move to InputElement as no scenario state is used anymore
    input_element.slide.andand.controller_name == 'supply' ||  
      input_element.slide.andand.contains_chp_slider?
  end
end