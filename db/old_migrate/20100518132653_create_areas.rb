class CreateAreas < ActiveRecord::Migration

  def self.up
    create_table :areas, :force => true do |t|
      t.string :country
      t.float 'co2_price'
      t.float 'co2_percentage_free'
      t.float 'el_import_capacity'
      t.float 'el_export_capacity'
      t.float 'co2_emission_1990'
      t.float 'co2_emission_2009'
      t.float 'co2_emission_electricity_1990'
      t.float 'roof_surface_available_pv'
      t.float 'coast_line'
      t.float 'offshore_suitable_for_wind'
      t.float 'onshore_suitable_for_wind'
      t.float 'areable_land'
      t.float 'available_land'
      t.timestamps
    end

  end

  def self.down
    drop_table :areas
  end
end
