class RemoveOldDescription < ActiveRecord::Migration
  def self.up
    remove_column :page_titles, :content_short
    remove_column :page_titles, :content
    remove_column :slides, :description
    remove_column :input_elements, :description
    remove_column :input_elements, :explanation
  end

  def self.down
    add_column :page_titles, :content, :text
    add_column :page_titles, :content_short, :string
    add_column :slides, :description, :text
    add_column :input_elements, :description, :text
    add_column :input_elements, :explanation, :text
  end
end
