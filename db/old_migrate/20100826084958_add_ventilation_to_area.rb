class AddVentilationToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :recirculation, :float
    add_column :areas, :heat_recovery, :float
    add_column :areas, :ventilation_rate, :float
  end

  def self.down
    remove_column :areas, :recirculation
    remove_column :areas, :heat_recovery
    remove_column :areas, :ventilation_rate
  end
end
