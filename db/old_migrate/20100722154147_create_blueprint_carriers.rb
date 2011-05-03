class CreateBlueprintCarriers < ActiveRecord::Migration
  def self.up
    create_table :blueprint_carriers, :force => true do |t|
      t.integer :blueprint_id
      t.integer :excel_id
      t.string :key
      t.string :name
      t.boolean :infinite

      t.timestamps
    end
  end

  def self.down
    drop_table :blueprint_carriers
  end
end
