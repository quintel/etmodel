class RenameSlideSubheaders < ActiveRecord::Migration
  def self.up
    rename_column :slides, :sub_header, :general_sub_header
    rename_column :slides, :sub_header2, :group_sub_header
  end

  def self.down
    rename_column :slides, :group_sub_header, :sub_header2
    rename_column :slides, :general_sub_header, :sub_header
  end
end