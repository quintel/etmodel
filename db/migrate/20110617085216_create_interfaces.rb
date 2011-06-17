class CreateInterfaces < ActiveRecord::Migration
  def self.up
    create_table :interfaces do |t|
      t.string :key
      t.text :structure
      t.boolean :enabled

      t.timestamps
    end
    
    ViewNode::Root.find_each do |r|
      Interface.create!(
        :key       => r.key,
        :enabled   => true,
        :structure => r.tree_to_yml
      )
    end

    add_index :interfaces, :key
    add_index :interfaces, :enabled
  end

  def self.down
    drop_table :interfaces
  end
end
