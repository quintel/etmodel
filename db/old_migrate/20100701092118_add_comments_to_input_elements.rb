class AddCommentsToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :comments, :text
  end

  def self.down
    remove_column :input_elements, :comments
  end
end
