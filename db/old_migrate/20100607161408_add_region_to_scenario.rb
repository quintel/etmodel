class AddRegionToScenario < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :region, :string
  end

  def self.down
    remove_column :scenarios, :region
  end
end
