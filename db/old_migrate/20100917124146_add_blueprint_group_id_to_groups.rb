class AddBlueprintGroupIdToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :blueprint_group_id, :integer
    Group.update_all("blueprint_group_id = id")
  end

  def self.down
    remove_column :groups, :blueprint_group_id
  end
end
