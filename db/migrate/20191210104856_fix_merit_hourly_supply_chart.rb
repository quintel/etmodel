class FixMeritHourlySupplyChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'energy_chp_local_engine_biogas' => '#FDE97B',
    'energy_chp_local_engine_network_gas' => '#F0904C',
    'energy_chp_local_wood_pellets' => '#AA2D02',
    'industry_chp_wood_pellets' => '#771108',
  }

  def up
     ActiveRecord::Base.transaction do
      el_present = OutputElement.find_by_key(:merit_order_hourly_supply)

      # Remove old series
      OutputElementSerie.find_by(gquery: 'energy_chp_engine_biogas').destroy!
      OutputElementSerie.find_by(gquery: 'agriculture_chp_engine_biogas').destroy!
      OutputElementSerie.find_by(gquery: 'agriculture_chp_engine_network_gas').destroy!
      OutputElementSerie.find_by(gquery: 'agriculture_chp_supercritical_wood_pellets').destroy!
      OutputElementSerie.find_by(gquery: 'buildings_chp_engine_biogas').destroy!
      OutputElementSerie.find_by(gquery: 'buildings_collective_chp_network_gas').destroy!
      OutputElementSerie.find_by(gquery: 'buildings_collective_chp_wood_pellets').destroy!
      OutputElementSerie.find_by(gquery: 'households_collective_chp_biogas').destroy!
      OutputElementSerie.find_by(gquery: 'households_collective_chp_network_gas').destroy!
      OutputElementSerie.find_by(gquery: 'households_collective_chp_wood_pellets').destroy!

      # Add new series
      create_output_series(el_present, 'energy_chp_local_engine_biogas', 'energy_chp_local_engine_biogas', 5)
      create_output_series(el_present, 'energy_chp_local_engine_network_gas', 'energy_chp_local_engine_network_gas', 5)
      create_output_series(el_present, 'energy_chp_local_wood_pellets', 'energy_chp_local_wood_pellets', 5)
      create_output_series(el_present, 'industry_chp_wood_pellets', 'industry_chp_wood_pellets', 5)

    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_output_series(element, gquery, label, order_by, target_line: false, group: '')
    element.output_element_series.create!(output_series_attrs(gquery, label, order_by, target_line, group))
  end

  def output_series_attrs(gquery, label, order_by, target_line, group)
      {
        color: COLORS[gquery],
        gquery: gquery,
        is_target_line: target_line,
        label: label,
        order_by: order_by,
        group: group
      }
  end
end
