class ChangeDefaultValueOfLinkType < ActiveRecord::Migration
  def self.up
    change_column :links, :link_type, :integer, :default => false
  end

  def self.down
    change_column :links, :link_type, :integer, :default => true
  end
end
