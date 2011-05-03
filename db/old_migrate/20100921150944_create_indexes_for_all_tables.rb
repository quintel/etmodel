class CreateIndexesForAllTables < ActiveRecord::Migration
  def self.up
    add_index :descriptions, [:describable_id, :describable_type]
    add_index :year_values, [:value_by_year_id, :value_by_year_type]
    add_index :graph_datas, [:region_code]
    add_index :input_elements, [:slide_id]
    add_index :output_element_series, [:output_element_id]
    add_index :user_graphs, [:graph_data_id]
    add_index :expert_predictions, [:input_element_id]
    add_index :area_dependencies, [:dependable_id, :dependable_type]
    add_index :time_curve_entries, :graph_id
  end

  def self.down
    remove_index :descriptions, :column => [:describable_id, :describable_type]
    remove_index :year_values, :column => [:value_by_year_id, :value_by_year_type]
    remove_index :graph_datas, :column => [:region_code]
    remove_index :input_elements, :column => [:slide_id]
    remove_index :output_element_series, :column => [:output_element_id]
    remove_index :user_graphs, :column => [:graph_data_id]
    remove_index :expert_predictions, :column => [:input_element_id]
    remove_index :area_dependencies, :column => [:dependable_id, :dependable_type]
    remove_index :time_curve_entries, :column => :graph_id
  
  end
end
