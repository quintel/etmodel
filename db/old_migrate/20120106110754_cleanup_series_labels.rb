class CleanupSeriesLabels < ActiveRecord::Migration
  def self.up
    OutputElementSerie.find_each do |s|
      unless s.label.blank?
        new_label = s.label.parameterize.gsub('-', '_')
        s.update_attribute :label, new_label
      end

      unless s.group.blank?
        new_group = s.group.parameterize.gsub('-', '_')
        s.update_attribute :group, new_group
      end

    end
  end

  def self.down
  end
end
