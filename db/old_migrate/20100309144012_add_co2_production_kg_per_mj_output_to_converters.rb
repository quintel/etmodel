class AddCo2ProductionKgPerMjOutputToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :co2_production_kg_per_mj_output, :float
  end

  def self.down
    remove_column :converters, :co2_production_kg_per_mj_output
  end
end
