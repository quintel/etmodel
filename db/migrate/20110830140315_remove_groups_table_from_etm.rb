class RemoveGroupsTableFromEtm < ActiveRecord::Migration
  def self.up
    drop_table :groups
  end

  def self.down
  end
end
