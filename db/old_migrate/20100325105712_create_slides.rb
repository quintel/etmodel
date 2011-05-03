class CreateSlides < ActiveRecord::Migration
  def self.up
    create_table :slides do |t|
      t.string :controller_name
      t.string :action_name
      t.string :name
      t.integer :order_by
      t.integer :default_output_element_id
      t.text :description
      t.string :image

      t.timestamps
    end
  end

  def self.down
    drop_table :slides
  end
end
