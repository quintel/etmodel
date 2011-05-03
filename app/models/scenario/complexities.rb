class Scenario < ActiveRecord::Base

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
    self[:complexity] = param.andand.to_i
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


end