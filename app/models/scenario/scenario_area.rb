##
# Area related methods for scenario
#
class Scenario < ActiveRecord::Base

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
  def has_buildings?
    area.andand.has_buildings == true
  end

  ##
  # @untested 2011-01-23 rob
  # 
  def has_agriculture?
    area.andand.has_agriculture == true
  end

  ##
  # @tested 2010-11-30 seb
  # 
  def use_network_calculations?
    area.andand.use_network_calculations == true
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
  def area_country
    Area.find_by_country(country)
  end

  ##
  # @tested 2010-12-06 seb
  # 
  def area_region
    Area.find_by_country(Current.scenario.region)
  end

  ##
  # @tested 2010-11-30 seb
  # 
  def area
    @area ||= Area.find_by_country(region_or_country)
  end



end