class CreateBlackboxOutputSeries < ActiveRecord::Migration
  def self.up
    create_table :blackbox_output_series, :force => true do |t|
      t.integer :blackbox_id
      t.integer :blackbox_scenario_id
      t.integer :output_element_serie_id

      t.decimal :present_value, :precision => 30
      t.decimal :future_value, :precision => 30

      t.timestamps
    end
  end

  def self.down
    drop_table :blackbox_output_series
  end
end
