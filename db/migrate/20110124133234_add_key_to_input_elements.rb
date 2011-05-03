class AddKeyToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :key, :string
  end

  def self.down
    remove_column :input_elements, :key
  end
end
