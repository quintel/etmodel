class FixMvDemandCurveChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'mv_energy_heat_load_curve' => '#FDE97B',
  }

  def up
     ActiveRecord::Base.transaction do
      el_present = OutputElement.find_by_key(:mv_demand_curves)

      # Remove old series
      OutputElementSerie.find_by(gquery: 'mv_buildings_space_heating_load_curve').destroy!
      OutputElementSerie.find_by(gquery: 'mv_households_space_heating_load_curve').destroy!

      # Add new series
      create_output_series(el_present, 'mv_energy_heat_load_curve', 'mv_energy_heat_load_curve', 2)

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
