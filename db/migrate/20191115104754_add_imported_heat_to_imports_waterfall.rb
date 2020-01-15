class AddImportedHeatToImportsWaterfall < ActiveRecord::Migration[5.2]
  COLORS = {
    'imported_heat_value_in_present_energy_imports' => '#E84118',
    'imported_heat_value_in_future_energy_imports' => '#E84118'
  }

  def up
     ActiveRecord::Base.transaction do
      el_present = OutputElement.find_by_key(:present_energy_imports)
      create_output_series(el_present, 'imported_heat_value_in_present_energy_imports', 'imported_heat_waterfall', 10,  group: 'present')

      el_future = OutputElement.find_by_key(:future_energy_imports)
      create_output_series(el_future, 'imported_heat_value_in_future_energy_imports', 'imported_heat_waterfall', 10, group: 'future')
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElementSerie.find_by(gquery: 'imported_heat_value_in_present_energy_imports').destroy!
      OutputElementSerie.find_by(gquery: 'imported_heat_value_in_future_energy_imports').destroy!
    end
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