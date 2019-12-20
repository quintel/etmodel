class FixSourceHeatElectricityIndustryChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'collective_heat_in_source_of_heat_and_electricity_in_industry' => '#F9CA24'
  }

  def up
     ActiveRecord::Base.transaction do
      # Remove old series
      OutputElementSerie.find_by(gquery: 'centrally_produced_heat_in_source_of_heat_and_electricity_in_industry').destroy!

      el = OutputElement.find_by_key(:source_of_heat_and_electricity_in_industry)
      # Add new series
      create_output_series(el, 'collective_heat_in_source_of_heat_and_electricity_in_industry', 'collective_heat_in_source_of_heat_and_electricity_in_industry', 3)
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
