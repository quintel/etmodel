class AddOrderToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :order_by, :float
  end

  def self.down
    remove_column :input_elements, :order_by
  end
end
