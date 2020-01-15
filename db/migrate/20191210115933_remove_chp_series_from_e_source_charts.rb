class RemoveChpSeriesFromESourceCharts < ActiveRecord::Migration[5.2]
  def up
     ActiveRecord::Base.transaction do
      # Remove old series
      OutputElementSerie.find_by(gquery: 'collective_chps_in_source_of_electricity_in_households').destroy!
      OutputElementSerie.find_by(gquery: 'chps_in_source_of_electricity_in_buildings').destroy!
      OutputElementSerie.find_by(gquery: 'chp_electricity_in_source_of_heat_and_electricity_in_agriculture').destroy!
      OutputElementSerie.find_by(gquery: 'chp_heat_in_source_of_heat_and_electricity_in_agriculture').destroy!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
