class AddH2CostCapacityChart < ActiveRecord::Migration[5.1]
  def up
    chart = OutputElement.create!(
      key: :hydrogen_cost_capacity,
      output_element_type: OutputElementType.find_by_name(:cost_capacity_bar),
      group: 'Supply',
      sub_group: 'hydrogen',
      requires_merit_order: true
    )

    series = {
      energy_hydrogen_biomass_gasification_ccs_h2_chart: '#A4B0BE',
      energy_hydrogen_biomass_gasification_h2_chart: '#DFE4EA',
      energy_hydrogen_flexibility_p2g_electricity_h2_chart: '#786FA6',
      energy_hydrogen_solar_pv_solar_radiation_h2_chart: '#87CEEB',
      energy_hydrogen_steam_methane_reformer_ccs_h2_chart: '#E69567',
      energy_hydrogen_steam_methane_reformer_h2_chart: '#FDE97B',
      energy_hydrogen_wind_turbine_offshore_h2_chart: '#63A1C9',
      energy_imported_hydrogen_backup_h2_chart: '#A7A1C5',
      energy_imported_hydrogen_baseload_h2_chart: '#C6C2DA'
    }

    series.each.with_index do |(key, color), index|
      chart.output_element_series.create!(
        gquery: key,
        label: key.to_s.chomp('_h2_chart'),
        order_by: index + 1,
        color: color
      )
    end
  end

  def down
    OutputElement.find_by_key!(:hydrogen_cost_capacity).destroy!
  end
end
