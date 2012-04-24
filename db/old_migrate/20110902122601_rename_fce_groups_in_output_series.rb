class RenameFceGroupsInOutputSeries < ActiveRecord::Migration
  def self.up
    OutputElementSerie.where(:group => "1.&nbsp;Extraction").each do |s|
      s.update_attributes(:group => "Extraction")
    end
    OutputElementSerie.where(:group => "2.&nbsp;Treatment").each do |s|
      s.update_attributes(:group => "Treatment")
    end
    OutputElementSerie.where(:group => "3.&nbsp;Transportation").each do |s|
      s.update_attributes(:group => "Transportation")
    end
    OutputElementSerie.where(:group => "4.&nbsp;Conversion").each do |s|
      s.update_attributes(:group => "Conversion")
    end
  end

  def self.down
  end
end
