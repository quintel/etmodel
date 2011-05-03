class CreateOutputElements < ActiveRecord::Migration
  def self.up
    create_table :output_elements do |t|
      t.string :name
      t.integer :output_element_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :output_elements
  end
end
