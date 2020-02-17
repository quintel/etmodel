class HeatInfraCostChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'heat_infrastructure_indoor_annualised_costs' => '#6AB04C',
    'heat_infrastructure_secondary_distribution_pipelines_annualised_costs' => '#E84118',
    'heat_infrastructure_distribution_stations_annualised_costs' => '#F9CA24',
    'heat_infrastructure_primary_distribution_pipelines_annualised_costs' => '#0984E3',
    'heat_infrastructure_storage_annualised_costs' => '#416B86',
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :heat_infrastructure_annualised_costs,
        group: 'Cost',
        output_element_type: OutputElementType.find_by_name(:vertical_stacked_bar),
        unit: 'euro'
      )

      create_output_series(el, 'heat_infrastructure_secondary_distribution_pipelines_annualised_costs', 'heat_infrastructure_secondary_distribution_pipelines_annualised_costs', 1)
      create_output_series(el, 'heat_infrastructure_primary_distribution_pipelines_annualised_costs', 'heat_infrastructure_primary_distribution_pipelines_annualised_costs', 2)
      create_output_series(el, 'heat_infrastructure_distribution_stations_annualised_costs', 'heat_infrastructure_distribution_stations_annualised_costs', 3)
      create_output_series(el, 'heat_infrastructure_indoor_annualised_costs', 'heat_infrastructure_indoor_annualised_costs', 4)
      create_output_series(el, 'heat_infrastructure_storage_annualised_costs', 'heat_infrastructure_storage_annualised_costs', 5)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:heat_infrastructure_annualised_costs).destroy!
    end
  end

  private

  def create_output_series(element, gquery, label, order_by, target_line=false)
    element.output_element_series.create!(output_series_attrs(gquery, label, order_by, target_line))
  end

  def output_series_attrs(gquery, label, order_by, target_line)
      {
        color: COLORS[gquery],
        gquery: gquery,
        is_target_line: target_line,
        label: label,
        order_by: order_by
      }
  end
end

