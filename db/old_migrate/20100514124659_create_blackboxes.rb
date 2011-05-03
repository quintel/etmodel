class CreateBlackboxes < ActiveRecord::Migration
  def self.up
    create_table :blackboxes do |t|
      t.string :name
      t.text :description
      t.integer :graph_id
      t.timestamps
    end
  end

  def self.down
    drop_table :blackboxes
  end
end
