class ChangePriceToLabelLabelQuery < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :label_query, :string
    rename_column :input_elements, :price, :label
  end

  def self.down
    remove_column :input_elements, :label_query
    rename_column :input_elements, :label, :price
  end
end
