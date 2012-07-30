class RemoveManyToManySliders < ActiveRecord::Migration
  def up
    add_column :input_elements, :slide_id, :integer
    add_column :input_elements, :position, :integer
    add_index :input_elements, :slide_id
    add_index :input_elements, :position

    InputElement.reset_column_information

    InputElement.find_each do |i|
      i.slider_positions.each do |pos|
        i.update_attributes({
          :slide_id => pos.slide_id,
          :position => pos.position
          })
      end
    end

    drop_table :slider_positions
  end

  def down
  end
end
