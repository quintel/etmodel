class RemoveInputGroup < ActiveRecord::Migration
  def self.up
    drop_table :input_element_groups
  end

  def self.down
  end
end
