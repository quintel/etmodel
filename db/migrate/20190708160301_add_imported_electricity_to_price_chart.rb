class AddImportedElectricityToPriceChart < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do
      chart.output_element_series.create!(
        label: 'imported_electricity_price_curve',
        gquery: 'imported_electricity_price_curve',
        order_by: 1,
        color: '#a9a9a9'
      )

      series(:merit_order_price_curve).update_attributes!(
        is_target_line: true,
        order_by: 2
      )

      slide = Slide.find_by_key(:costs_imported_electricity)
      slide.update_attributes!(output_element: chart)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      series(:imported_electricity_price_curve).destroy!

      series(:merit_order_price_curve).update_attributes!(
        is_target_line: false,
        order_by: 1
      )

      Slide.find_by_key(:costs_imported_electricity).update_attributes!(
        output_element: OutputElement.find_by_key(:merit_order)
      )
    end
  end

  private

  def chart
    OutputElement.find_by_key(:merit_order_price_curve)
  end

  def series(gquery)
    chart.output_element_series.find_by_gquery(gquery)
  end
end
