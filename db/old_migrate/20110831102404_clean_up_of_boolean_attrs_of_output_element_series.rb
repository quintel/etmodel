class CleanUpOfBooleanAttrsOfOutputElementSeries < ActiveRecord::Migration
  def self.up
    OutputElementSerie.where(:show_at_first => false).each do |s|
      s.update_attributes(:show_at_first => nil)
    end

    OutputElementSerie.where(:is_target_line => false).each do |s|
      s.update_attributes(:is_target_line => nil)
    end

    OutputElementSerie.all.each do |s|
      if s.is_target_line.blank?
        s.update_attributes(:is_target_line => nil)
      end
    end

  end

  def self.down
  end
end
