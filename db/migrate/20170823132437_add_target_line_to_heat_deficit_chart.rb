class AddTargetLineToHeatDeficitChart < ActiveRecord::Migration[5.0]
  def up
    chart = OutputElement.find_by_key(:heat_deficit)

    2.times do |i|
      OutputElementSerie.create!(
        output_element: chart,
        gquery: 'heat_producer_demand_in_households',
        color: '#FF0000',
        label: :total_demand,
        order_by: 24 + i,
        is_target_line: true,
        target_line_position: 1 + i
      )
    end
  end

  def down
    OutputElementSerie
      .where(gquery: 'heat_producer_demand_in_households')
      .destroy_all
  end
end
