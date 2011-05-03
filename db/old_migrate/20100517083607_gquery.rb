class Gquery < ActiveRecord::Migration
  def self.up
    create_table :gqueries, :force => true do |t|
      t.string :key, :unique => true
      t.text :query
      t.string :name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :gqueries
  end
end
