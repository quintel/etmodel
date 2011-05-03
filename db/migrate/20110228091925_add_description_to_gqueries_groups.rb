class AddDescriptionToGqueriesGroups < ActiveRecord::Migration
  def self.up
    add_column :gquery_groups, :description, :text
  end

  def self.down
    remove_column :gquery_groups, :description
  end
end
