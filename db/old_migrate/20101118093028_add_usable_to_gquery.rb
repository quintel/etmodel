class AddUsableToGquery < ActiveRecord::Migration
  def self.up
    
    unless Gquery.column_names.include? 'usable_for_optimizer'
      add_column(:gqueries, :usable_for_optimizer, :boolean, :default => false)
    end
        
    keys_affected = %w[co2_emission net_energy_import net_electricity_import total_energy_cost electricity_cost onshore_land onshore_coast offshore land_for_solar_panels land_for_csp not_renewable_percentage]
    
    keys_affected.each do |key|
      gquery = Gquery.find_by_key(key)
      gquery.destroy if gquery
    end
    
    execute ("
      INSERT INTO `gqueries` (`key`,`query`,`name`,`description`,`created_at`,`updated_at`,`not_cacheable`,`usable_for_optimizer`)
      VALUES
      ('co2_emission', 'UNIT(Q(co2_emission_total);billions)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('net_energy_import', 'Q(energy_dependence)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('net_electricity_import', 'Q(electricity_dependence)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('total_energy_cost', 'UNIT(Q(cost_total);billions)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('electricity_cost', 'PRODUCT(SECS_PER_HOUR,Q(avg_total_cost_for_electricity_production_per_mj))', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('onshore_land', 'V(wind_inland_energy;total_land_use)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('onshore_coast', 'V(wind_coastal_energy;total_land_use)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('offshore', 'V(wind_offshore_energy;total_land_use)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('roofs_for_solar_panels', 'V(local_solar_pv_grid_connected_energy_energetic;total_land_use)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('land_for_solar_panels', 'V(solar_pv_central_production_energy_energetic;total_land_use)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('land_for_csp', 'V(solar_csp_energy;total_land_use)', NULL, NULL, '2010-11-07 19:31:42', '2010-11-07 19:31:42', 0, 1),
      ('not_renewable_percentage', 'SUM(\n	1, NEG(\n		Q(share_of_renewable_energy)\n	)\n)', NULL, NULL, '2010-11-01 12:03:14', '2010-11-01 12:03:14', 0, 1);
    ")
  
  end
    
  def self.down
    remove_column :gqueries, :usable_for_optimizer
  end
  
end
