class CreateTimeseries < ActiveRecord::Migration
  def self.up
    create_table :time_curve_entries, :force => true do |t|
      t.integer :graph_id
      t.integer :converter_excel_id
      t.integer :year
      t.float :value
      t.string :changing_attribute
      t.timestamps
    end
  end

  def self.down
    drop_table :time_curve_entries
  end
end
