class AddOutputElementsForMerit < ActiveRecord::Migration
  def change
    merit_order_price_curve = OutputElement.create!(
      group: 'Merit',
      key: 'merit_order_price_curve',
      requires_merit_order: true,
      output_element_type_id: 16
    )

    OutputElementSerie.create!(
      label: 'merit_price',
      color: '#5D7929',
      gquery: 'merit_order_price_curve',
      output_element: merit_order_price_curve,
      unit: "EUR/MWh"
    )
  end
end
