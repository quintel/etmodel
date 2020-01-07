class FixHydrogenMekko < ActiveRecord::Migration[5.2]
  COLORS = {
    'energy_heat_from_hydrogen_for_mekko' => '#E69567',
  }

  def up
     ActiveRecord::Base.transaction do
      el_present = OutputElement.find_by_key(:mekko_of_hydrogen_network)

      # Remove old series
      OutputElementSerie.find_by(gquery: 'buildings_collective_burner_hydrogen_for_mekko').destroy!
      OutputElementSerie.find_by(gquery: 'households_collective_burner_hydrogen_for_mekko').destroy!

      # Add new series
      create_output_series(el_present, 'energy_heat_from_hydrogen_for_mekko', 'energy_heat_from_hydrogen_for_mekko', 7,  group: 'demand')

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