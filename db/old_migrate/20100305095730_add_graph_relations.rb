class AddGraphRelations < ActiveRecord::Migration
  def self.up
    add_column :converters, :graph_id, :integer
    add_column :converters, :excel_id, :integer

    add_column :conversions, :graph_id, :integer
    add_column :conversions, :excel_id, :integer

    add_column :carriers, :graph_id, :integer
    add_column :carriers, :excel_id, :integer

    add_column :links, :graph_id, :integer
    add_column :links, :excel_id, :integer
  end


  def self.down
    remove_column :converters, :graph_id
    remove_column :converters, :excel_id

    remove_column :conversions, :graph_id
    remove_column :conversions, :excel_id

    remove_column :carriers, :graph_id
    remove_column :carriers, :excel_id

    remove_column :links, :graph_id
    remove_column :links, :excel_id
  end
end
