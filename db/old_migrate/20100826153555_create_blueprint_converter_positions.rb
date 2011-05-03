class CreateBlueprintConverterPositions < ActiveRecord::Migration
  def self.up
    create_table :blueprint_converter_positions, :force => true do |t|
      t.integer :blueprint_converter_id
      t.integer :x
      t.integer :y
      t.timestamps
    end
  end

  def self.down
    #drop_table :blueprint_converter_positions
  end
end
