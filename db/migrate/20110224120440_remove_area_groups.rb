class RemoveAreaGroups < ActiveRecord::Migration
  def self.up
     drop_table :areagroups
     drop_table :areagroups_areas
  end

  def self.down
  end
end
