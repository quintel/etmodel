class RemoveInputIdFromInputElement < ActiveRecord::Migration
  def up
    remove_column :input_elements, :input_id
  end

  def down
    add_column :input_elements, :input_id, :integer
  end
end
