class RemoveUnusedInputElementAttrs < ActiveRecord::Migration
  def self.up
    remove_column :input_elements, :slide_id
    remove_column :input_elements, :locked_for_municipalities
    remove_column :input_elements, :update_type
    remove_column :input_elements, :factor
    remove_column :input_elements, :complexity
    remove_column :input_elements, :order_by
  end

  def self.down
    add_column :input_elements, :order_by, :float
    add_column :input_elements, :complexity, :integer,                :default => 1
    add_column :input_elements, :factor, :float
    add_column :input_elements, :update_type, :string
    add_column :input_elements, :locked_for_municipalities, :boolean
    add_column :input_elements, :slide_id, :integer
  end
end
