class AddComplexityToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :complexity, :integer
  end

  def self.down
    remove_column :input_elements, :complexity
  end
end
