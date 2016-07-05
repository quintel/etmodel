class AddImportToMeritHourlyLoadChart < ActiveRecord::Migration
  def up
    element.output_element_series.create!(
      color:  '#cccccc',
      label:  'imported_electricity',
      gquery: 'energy_interconnector_imported_electricity',
      group:  'flex',
      is_target_line: false,
      order_by: 5
    )
  end

  def down
    element.output_element_series
      .where(gquery: 'imported_electricity')
      .delete_all
  end

  private

  def element
    OutputElement.where(key: 'merit_order_hourly_supply').first!
  end
end
