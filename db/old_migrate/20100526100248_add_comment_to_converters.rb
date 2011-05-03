class AddCommentToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :comment, :text
  end

  def self.down
    remove_column :converters, :comment
  end
end
