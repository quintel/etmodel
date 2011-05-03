class AddIsShareGroupToInput < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :share_group, :integer
  end

  def self.down
    remove_column :input_elements, :share_group
  end
end
