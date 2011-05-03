class AddPointLabelToOutputElement < ActiveRecord::Migration
  def self.up
    add_column :output_elements, :show_point_label, :boolean
  end

  def self.down
    remove_column :output_elements, :show_point_label
  end
end
