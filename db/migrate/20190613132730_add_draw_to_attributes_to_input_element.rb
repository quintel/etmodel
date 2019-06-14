class AddDrawToAttributesToInputElement < ActiveRecord::Migration[5.2]
  def change
    add_column :input_elements, :draw_to_min, :float, after: :step_value
    add_column :input_elements, :draw_to_max, :float, after: :draw_to_min
  end
end
