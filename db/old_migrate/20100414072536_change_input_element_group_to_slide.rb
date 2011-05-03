class ChangeInputElementGroupToSlide < ActiveRecord::Migration
  def self.up
    rename_column :input_elements, :input_element_group_id, :slide_id
  end

  def self.down
    rename_column :input_elements, :slide_id, :input_element_group_id
  end
end
