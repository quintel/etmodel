class AddHydrogenProductionChart < ActiveRecord::Migration[5.1]
  def up
    chart = OutputElement.create!(
      key: :hydrogen_production,
      output_element_type: OutputElementType.find_by_name(:demand_curve),
      unit: 'MW',
      group: 'Supply',
      sub_group: 'hydrogen',
      requires_merit_order: true
    )

    series = {
      energy_hydrogen_biomass_gasification_ccs_hydrogen_output_curve: ['#A4B0BE'],
      energy_hydrogen_biomass_gasification_hydrogen_output_curve: ['#DFE4EA'],
      energy_hydrogen_electrolysis_solar_electricity_hydrogen_output_curve: ['#87CEEB'],
      energy_hydrogen_electrolysis_wind_electricity_hydrogen_output_curve: ['#63A1C9'],
      energy_hydrogen_flexibility_p2g_electricity_hydrogen_output_curve: ['#786FA6'],
      energy_hydrogen_steam_methane_reformer_ccs_hydrogen_output_curve: ['#E69567'],
      energy_hydrogen_steam_methane_reformer_hydrogen_output_curve: ['#FDE97B'],
      energy_imported_hydrogen_distribution_hydrogen_output_curve: ['#A7A1C5', 'imported_hydrogen'],
      energy_hydrogen_storage_hydrogen_output_curve: ['#A2D679', 'hydrogen_storage']
    }

    chart.output_element_series.create(
      gquery: :hydrogen_demand_curve,
      label: :hydrogen_demand,
      order_by: 1,
      color: '#CC0000',
      is_target_line: true
    )

    series.each.with_index do |(key, (color, label)), index|
      chart.output_element_series.create!(
        gquery: key,
        label: label || key.to_s.chomp('_hydrogen_output_curve'),
        order_by: index + 2,
        color: color
      )
    end
  end

  def down
    OutputElement.find_by_key(:hydrogen_production).destroy
  end
end
