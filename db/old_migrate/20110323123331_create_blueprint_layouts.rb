class CreateBlueprintLayouts < ActiveRecord::Migration
  def self.up
    create_table :blueprint_layouts, :force => true  do |t|
      t.string :key
      t.timestamps
    end
  end

  def self.down
    drop_table :blueprint_layouts
  end
end
