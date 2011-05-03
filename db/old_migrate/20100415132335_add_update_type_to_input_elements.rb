class AddUpdateTypeToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :update_type, :string
    InputElement.update_all('update_type = "converters"')
  end

  def self.down
    remove_column :input_elements, :update_type
  end
end
