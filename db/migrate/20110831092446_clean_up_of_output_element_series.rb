class CleanUpOfOutputElementSeries < ActiveRecord::Migration
  def self.up
    OutputElementSerie.where(:output_element_id => [41,59,64])
    OutputElementSerie.all.reject{|s| [100,105,107,55,52,50,32,47].include?(s.output_element_id)}.each do |s|
      s.update_attributes(:group => nil)
    end

    remove_column :output_element_series, :expert_key
    remove_column :output_element_series, :historic_key
    remove_column :output_element_series, :key
    rename_column :output_element_series, :position, :target_line_position
    rename_column :output_element_series, :is_target, :is_target_line
  end

  def self.down
    change_column :table_name, :column_name, :string
    rename_column :output_element_series, :is_target_line, :is_target
    rename_column :output_element_series, :target_line_position, :position
    add_column :output_element_series, :expert_key, :string
    add_column :output_element_series, :historic_key, :string
    add_column :output_element_series, :key, :string    
  end
end