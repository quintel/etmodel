class RemoveUnusedLinkDataAttributes < ActiveRecord::Migration
  def self.up
    remove_column :link_datas, :value
    remove_column :link_datas, :priority
    remove_column :link_datas, :carrier_id
    remove_column :link_datas, :excel_id
  end

  def self.down
    add_column :link_datas, :excel_id, :integer
    add_column :link_datas, :carrier_id, :integer
    add_column :link_datas, :priority, :boolean
    add_column :link_datas, :value, :float
  end
end
