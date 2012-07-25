class CreateSliderPositions < ActiveRecord::Migration
  def self.up
    create_table :slider_positions do |t|
      t.integer :slide_id
      t.integer :slider_id
      t.integer :position
    end
    add_index :slider_positions, :slide_id
    add_index :slider_positions, :slider_id

    InputElement.find_each do |i|
      p = SliderPosition.create(
        :slide_id => i.slide_id,
        :slider_id => i.id,
        :position => i.position
      )
    end

    remove_column :input_elements, :slide_id
    remove_column :input_elements, :position
  end

  def self.down
    drop_table :slider_positions
  end
end
