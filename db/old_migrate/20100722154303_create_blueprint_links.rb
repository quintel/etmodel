class CreateBlueprintLinks < ActiveRecord::Migration
  def self.up
    create_table :blueprint_links, :force => true do |t|
      t.integer :blueprint_id
      t.integer :parent_id
      t.integer :child_id
      t.integer :blueprint_carrier_id
      t.integer :link_type
    end
  end

  def self.down
    drop_table :blueprint_links
  end
end
