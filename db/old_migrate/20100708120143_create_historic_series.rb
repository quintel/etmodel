class CreateHistoricSeries < ActiveRecord::Migration
  def self.up
    create_table :historic_series do |t|
      t.string :key
      t.integer :area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :historic_series
  end
end
