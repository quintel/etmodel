class AddUpdateInputToInput < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :update_elements, :string
  end

  def self.down
    remove_column :input_elements, :update_elements
  end
end
