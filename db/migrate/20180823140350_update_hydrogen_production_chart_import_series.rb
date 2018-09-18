class UpdateHydrogenProductionChartImportSeries < ActiveRecord::Migration[5.1]
  def up
    element = OutputElement.find_by_key!(:hydrogen_production)

    # Rename distribution to backup...

    backup_series = element.output_element_series.find_by_gquery!(
      :energy_imported_hydrogen_distribution_hydrogen_output_curve
    )

    backup_series.update_attributes!(
      gquery: :energy_imported_hydrogen_backup_hydrogen_output_curve,
      label: :imported_hydrogen_backup
    )

    # Increment order_by for later series, making room for "baseload"...

    series_after(element, backup_series).each do |series|
      series.order_by += 1
      series.save!
    end

    # Add baseload...

    element.output_element_series.create(
      color: '#C6C2DA',
      gquery: :energy_imported_hydrogen_baseload_hydrogen_output_curve,
      label: :imported_hydrogen_baseload,
      order_by: backup_series.order_by + 1
    )
  end

  def down
    element = OutputElement.find_by_key!(:hydrogen_production)

    backup_series = element.output_element_series.find_by_gquery!(
      :energy_imported_hydrogen_backup_hydrogen_output_curve
    )

    # Change "backup" back to "distribution"...

    backup_series.update_attributes!(
      gquery: :energy_imported_hydrogen_distribution_hydrogen_output_curve,
      label: :imported_hydrogen
    )

    baseload_series = element.output_element_series.find_by_gquery!(
      :energy_imported_hydrogen_baseload_hydrogen_output_curve
    )

    # Decrement order_by for series after "baseload" to full the gap which will
    # be left...

    series_after(element, baseload_series).each do |series|
      series.order_by -= 1
      series.save!
    end

    # Remove baseload...

    baseload_series.destroy!
  end

  private

  def series_after(element, series)
    element.output_element_series.where('order_by > ?', series.order_by)
  end
end
