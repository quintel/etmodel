class RenameInputeElementsGroupId < ActiveRecord::Migration
  def self.up
    rename_column :input_elements, :input_elements_group_id, :input_element_group_id
  end

  def self.down
    rename_column :input_elements, :input_element_group_id, :input_elements_group_id
  end
end
