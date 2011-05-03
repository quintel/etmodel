class CreateInputElementsTable < ActiveRecord::Migration
  def self.up
      create_table :input_elements do |t|
        t.string :name
        t.text :description
        t.decimal :min_value
        t.decimal :max_value
        t.decimal :step_value
        t.decimal :start_value
        t.integer :input_elements_group_id
        t.timestamps
      end
  end

  def self.down
    drop_table :input_elements
  end


end
