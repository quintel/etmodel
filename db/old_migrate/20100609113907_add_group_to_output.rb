class AddGroupToOutput < ActiveRecord::Migration
  def self.up
    add_column :output_elements, :group, :string
  end

  def self.down
    remove_column :output_elements, :group
  end
end
