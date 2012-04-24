class AddCspAndOldTechToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :has_solar_csp, :boolean
    add_column :areas, :has_old_technologies, :boolean
  end

  def self.down
    remove_column :areas, :has_old_technologies
    remove_column :areas, :has_solar_csp
  end
end