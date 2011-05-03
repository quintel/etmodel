class CreateBlackboxGqueries < ActiveRecord::Migration
  def self.up
    create_table :blackbox_gqueries do |t|
      t.integer :blackbox_id
      t.integer :blackbox_scenario_id
      t.integer :gquery_id

      t.decimal :present_value, :precision => 30
      t.decimal :future_value, :precision => 30

      t.timestamps
    end
  end

  def self.down
    drop_table :blackbox_gqueries
  end
end
