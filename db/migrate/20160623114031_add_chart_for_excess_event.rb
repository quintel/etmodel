class AddChartForExcessEvent < ActiveRecord::Migration
  def change
    output_element = OutputElement.create!(
      output_element_type_id: 16,
      group: 'Merit',
      key: 'merit_order_excess_events'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'excess',
      color: '#4169E1',
      gquery: 'number_of_excess_events',
      is_target_line: false
    )
  end
end
