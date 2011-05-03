##
# Class for all user settings that should persist over a session.
#
class Setting
  DEFAULT_ATTRIBUTES = {
    :show_municipality_introduction => true,
    :hide_unadaptable_sliders => false,
    :network_parts_affected => [],
    :track_peak_load => true
  }

  attr_accessor :show_municipality_introduction,
                :hide_unadaptable_sliders,
                :network_parts_affected,
                :track_peak_load,
                :last_etm_controller_name,
                :last_etm_controller_action

  ##
  # @tested 2010-12-06 seb
  #
  def initialize(attributes = {}) 
    attributes = self.class.default_attributes.merge(attributes)
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end
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

end