class AddPriceToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :price, :string, :after => "name"
  end

  def self.down
    remove_column :input_elements, :price
  end
end
