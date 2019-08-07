class RemoveTargetsTable < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        drop_table :targets
      end

      dir.down do
        create_table :targets do |t|
          t.string :code
          t.string :query
          t.string :unit
          t.datetime :created_at
          t.datetime :updated_at
          t.string :display_format
          t.string :reached_query
          t.string :target_query
          t.index [:code], name: "index_policy_goals_on_key"
        end

        execute <<-SQL
          INSERT INTO `targets` (`id`, `code`, `query`, `unit`, `created_at`, `updated_at`, `display_format`, `reached_query`, `target_query`)
          VALUES
            (1, 'co2_emissions', 'policy_goal_co2_emissions_value', 'MT', '2010-07-19 12:09:15', '2011-11-17 12:36:52', 'number_with_unit', 'policy_goal_co2_emissions_reached', 'policy_goal_co2_emissions_target_value'),
            (2, 'net_energy_import', 'policy_goal_net_energy_import_value', 'pct', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'percentage', 'policy_goal_net_energy_import_reached', 'policy_goal_net_energy_import_target_value'),
            (3, 'net_electricity_import', 'policy_goal_net_electricity_import_value', 'pct', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'percentage', 'policy_goal_net_electricity_import_reached', 'policy_goal_net_electricity_import_target_value'),
            (4, 'total_energy_costs', 'policy_goal_total_energy_costs_value', '&euro; bln', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'number_with_unit', 'policy_goal_total_energy_costs_reached', 'policy_goal_total_energy_costs_target_value'),
            (5, 'electricity_costs', 'policy_goal_electricity_costs_value', '&euro;/MWh', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'number_with_unit', 'policy_goal_electricity_costs_reached', 'policy_goal_electricity_costs_target_value'),
            (6, 'renewable_percentage', 'policy_goal_renewable_percentage_value', 'pct', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'percentage', 'policy_goal_renewable_percentage_reached', 'policy_goal_renewable_percentage_target_value'),
            (7, 'onshore_land', 'policy_goal_onshore_land_value', 'km&sup2;', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'number_with_unit', 'policy_goal_onshore_land_reached', 'policy_goal_onshore_land_target_value'),
            (8, 'onshore_coast', 'policy_goal_onshore_coast_value', 'km', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'number_with_unit', 'policy_goal_onshore_coast_reached', 'policy_goal_onshore_coast_target_value'),
            (9, 'offshore', 'policy_goal_offshore_value', 'km&sup2;', '2010-07-19 12:09:15', '2011-07-15 07:47:45', 'number_with_unit', 'policy_goal_offshore_reached', 'policy_goal_offshore_target_value');
        SQL
      end
    end
  end
end
