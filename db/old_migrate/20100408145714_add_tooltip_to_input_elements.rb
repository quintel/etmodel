class AddTooltipToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :explanation, :string
  end

  def self.down
    remove_column :input_elements, :explanation
  end
end
