class AddNewSidebars < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM `sidebar_items`;"
    execute "INSERT INTO `sidebar_items` (`id`,`name`,`key`,`section`,`percentage_bar_query`,`order_by`,`created_at`,`updated_at`)
      VALUES
      	(1, 'Households', 'households', 'demand', 'future:Q(households_percentage_energy_use_of_total)', 1, NULL, NULL),
      	(2, 'Buildings', 'buildings', 'demand', 'future:Q(buildings_percentage_energy_use_of_total)', 2, NULL, NULL),
      	(3, 'Transportation', 'transport', 'demand', 'future:Q(transport_percentage_energy_use_of_total)', 3, NULL, NULL),
      	(4, 'Industry', 'industry', 'demand', 'future:Q(industry_percentage_energy_use_of_total)', 4, NULL, NULL),
      	(5, 'Agriculture', 'agriculture', 'demand', 'future:Q(agriculture_percentage_energy_use_of_total)', 5, NULL, NULL),
      	(6, 'Other', 'other', 'demand', 'future:Q(other_percentage_energy_use_of_total)', 6, NULL, NULL),
      	(12, 'Combustion plants', 'combustion', 'costs', '', 1, NULL, NULL),
      	(13, 'Nuclear plants', 'nuclear', 'costs', '', 2, NULL, NULL),
      	(14, 'Wind turbines', 'wind', 'costs', '', 3, NULL, NULL),
      	(15, 'Hydro electric', 'water', 'costs', '', 4, NULL, NULL),
      	(16, 'Solar power', 'solar', 'costs', '', 5, NULL, NULL),
      	(17, 'Geothermal', 'earth', 'costs', '', 6, NULL, NULL),
      	(18, 'CO2 emissions', 'co2', 'costs', '', 7, NULL, NULL),
      	(19, 'Sustainability targets', 'sustainability', 'policy', '', 1, NULL, NULL),
      	(20, 'Dependence', 'dependence', 'policy', '', 2, NULL, NULL),
      	(21, 'Cost', 'cost', 'policy', '', 3, NULL, NULL),
      	(22, 'Electricity', 'electricity', 'supply', '', 1, NULL, NULL),
      	(23, 'Renewable electricity', 'electricity_renewable', 'supply', '', 2, NULL, NULL),
      	(24, 'Fossil heat', 'fossil_heat', 'supply', '', 3, NULL, NULL),
      	(25, 'Renewable heat', 'renewable_heat', 'supply', '', 4, NULL, NULL),
      	(26, 'Transport fuels', 'transport', 'supply', '', 5, NULL, NULL),
      	(28, 'Infrastructure', 'infrastructure', 'supply', '', 6, NULL, NULL),
      	(29, 'Area use', 'area', 'policy', '', 4, NULL, NULL);"
    execute "INSERT INTO `gqueries` (`key`,`query`,`name`,`description`,`created_at`,`updated_at`,`not_cacheable`,`usable_for_optimizer`)
    VALUES
    	('other_percentage_energy_use_of_total', 'DIVIDE(\r\nSUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(other));final_demand)),\r\nSUM(V(G(final_demand_cbs);final_demand))\r\n)', NULL, '', '2010-12-21 16:00:44', '2010-12-21 16:00:44', 0, 0),
    	('industry_percentage_energy_use_of_total', 'DIVIDE(\r\nSUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(industry));final_demand)),\r\nSUM(V(G(final_demand_cbs);final_demand))\r\n)', NULL, '', '2010-12-21 16:00:00', '2010-12-21 16:00:00', 0, 0),
    	( 'agriculture_percentage_energy_use_of_total', 'DIVIDE(\r\nSUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(agriculture));final_demand)),\r\nSUM(V(G(final_demand_cbs);final_demand))\r\n)', NULL, '', '2010-12-21 15:59:28', '2010-12-21 15:59:28', 0, 0),
    	( 'transport_percentage_energy_use_of_total', 'DIVIDE(\r\nSUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(transport));final_demand)),\r\nSUM(V(G(final_demand_cbs);final_demand))\r\n)', NULL, '', '2010-12-21 15:58:53', '2010-12-21 15:58:53', 0, 0),
    	( 'buildings_percentage_energy_use_of_total', 'DIVIDE(\r\nSUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(buildings));final_demand)),\r\nSUM(V(G(final_demand_cbs);final_demand))\r\n)', NULL, '', '2010-12-21 15:58:38', '2010-12-21 15:58:38', 0, 0),
    	( 'households_percentage_energy_use_of_total', 'DIVIDE(\r\nSUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(households));final_demand)),\r\nSUM(V(G(final_demand_cbs);final_demand))\r\n)', NULL, '', '2010-12-21 15:56:42', '2010-12-21 15:56:57', 0, 0);
    "
  end

  def self.down
  end
end
