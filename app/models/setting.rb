##
# Class for all user settings that should persist over a session.
#
class Setting
  
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
                :selected_output_element
                

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
  # @tested 2010-12-07 seb
  #
  def track_peak_load?
    Current.scenario.use_peak_load and self.track_peak_load
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

end