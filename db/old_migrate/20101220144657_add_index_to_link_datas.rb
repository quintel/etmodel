class AddIndexToLinkDatas < ActiveRecord::Migration
  def self.up
    add_index :converter_datas, :graph_data_id
    add_index :link_datas, :graph_data_id
    add_index :links, :blueprint_id
    remove_column :converters, :blueprint_id
    add_index :blueprints_converters, :blueprint_id
    add_index :slot_datas, :graph_data_id
    add_index :slots, :blueprint_id
  end

  def self.down
    remove_index :slots, :blueprint_id
    remove_index :slot_datas, :graph_data_id
    add_column :converters, :blueprint_id, :integer
    remove_index :converters, :blueprint_id
    remove_index :converter_datas, :graph_data_id
    remove_index :links, :blueprint_id
    remove_index :link_datas, :graph_data_id
  end
end