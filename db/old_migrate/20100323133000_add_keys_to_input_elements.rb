class AddKeysToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :keys, :string
    add_column :input_elements, :attr_name, :string
  end

  def self.down
    remove_column :input_elements, :attr_name
    remove_column :input_elements, :keys
  end
end
