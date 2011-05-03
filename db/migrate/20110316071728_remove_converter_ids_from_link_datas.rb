class RemoveConverterIdsFromLinkDatas < ActiveRecord::Migration
  def self.up
    remove_column :link_datas, :parent_id
    remove_column :link_datas, :converter_id
  end

  def self.down
    add_column :link_datas, :converter_id, :integer
    add_column :link_datas, :parent_id, :integer
  end
end
