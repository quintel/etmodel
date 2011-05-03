class AddHasAgriToAreaData < ActiveRecord::Migration
  def self.up           
    add_column :areas, :has_agriculture, :boolean, :default => true
  end

  def self.down
    remove_column :areas, :has_agriculture
  end
end
