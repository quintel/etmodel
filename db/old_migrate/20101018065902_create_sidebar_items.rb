class CreateSidebarItems < ActiveRecord::Migration
  def self.up
    create_table :sidebar_items do |t|
      t.string :name
      t.string :key
      t.string :section
      t.text :percentage_bar_query
      t.integer :order_by
      t.timestamps
    end
    execute "INSERT INTO `sidebar_items` (`id`,`name`,`key`,`section`,`percentage_bar_query`,`created_at`,`updated_at`,`order_by`)
     VALUES
     	(1, 'Households', 'households', 'demand', 'future:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(households));final_demand))', NULL, NULL, 1),
     	(2, 'Buildings', 'buildings', 'demand', 'future:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(buildings));final_demand))', NULL, NULL, 2),
     	(3, 'Transportation', 'transport', 'demand', 'future:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(transport));final_demand))', NULL, NULL, 3),
     	(4, 'Industry', 'industry', 'demand', 'future:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(industry));final_demand))', NULL, NULL, 4),
     	(5, 'Agriculture', 'agriculture', 'demand', 'future:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(agriculture));final_demand))', NULL, NULL, 5),
     	(6, 'Other', 'other', 'demand', 'future:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(other));final_demand))', NULL, NULL, 6),
     	(12, 'Combustion plants', 'combustion', 'costs', '', NULL, NULL, 1),
     	(13, 'Nuclear plants', 'nuclear', 'costs', '', NULL, NULL, 2),
     	(14, 'Wind turbines', 'wind', 'costs', '', NULL, NULL, 3),
     	(15, 'Hydro electric', 'water', 'costs', '', NULL, NULL, 4),
     	(16, 'Solar power', 'solar', 'costs', '', NULL, NULL, 5),
     	(17, 'Geothermal', 'earth', 'costs', '', NULL, NULL, 6),
     	(18, 'CO2 emissions', 'co2', 'costs', '', NULL, NULL, 7),
     	(19, 'Sustainability targets', 'sustainability', 'policy', '', NULL, NULL, 1),
     	(20, 'Dependence', 'dependence', 'policy', '', NULL, NULL, 2),
     	(21, 'Cost', 'cost', 'policy', '', NULL, NULL, 3),
     	(22, 'Electricity', 'electricity', 'supply', '', NULL, NULL, 1),
     	(23, 'Renewable electricity', 'electricity_renewable', 'supply', '', NULL, NULL, 2),
     	(24, 'Fossil heat', 'fossil_heat', 'supply', '', NULL, NULL, 3),
     	(25, 'Renewable heat', 'renewable_heat', 'supply', '', NULL, NULL, 4),
     	(26, 'Transport fuels', 'transport', 'supply', '', NULL, NULL, 5),
     	(28, 'Infrastructure', 'infrastructure', 'supply', '', NULL, NULL, 6);"
  end

  def self.down
    drop_table :sidebar_items
  end
end
