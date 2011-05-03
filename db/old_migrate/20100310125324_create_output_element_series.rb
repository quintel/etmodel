class CreateOutputElementSeries < ActiveRecord::Migration
  def self.up
    create_table :output_element_series do |t|
      t.integer :output_element_id
      t.string :key
      t.integer :order
      t.string :label

      t.timestamps
    end
  end

  def self.down
    drop_table :output_element_series
  end
end
