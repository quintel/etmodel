class CreateBlueprintConverters < ActiveRecord::Migration
  def self.up

    create_table :blueprint_converters, :force => true do |t|
      t.integer :blueprint_id
      t.integer :excel_id
      t.string :key
      t.string :name
      t.integer :use_id
      t.integer :sector_id

      t.timestamps
    end
  end

  def self.down
    drop_table :blueprint_converters
  end
end
