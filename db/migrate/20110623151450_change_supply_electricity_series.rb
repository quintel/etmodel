class ChangeSupplyElectricitySeries < ActiveRecord::Migration
  def self.up
    o = OutputElementSerie.find(348)
    o.update_attribute :gquery, 'chart_demand_41_electricity_production_present'
    o = OutputElementSerie.find(349)
    o.update_attribute :gquery, 'chart_demand_41_electricity_production_future'
  end

  def self.down
  end
end
