class RenameSlideSubheaders < ActiveRecord::Migration
  def self.up
    rename_column :slides, :sub_header, :general_slider_type_info
    rename_column :slides, :sub_header2, :group_slider_type_info
    mncc
  end

  def self.down
    rename_column :slides, :group_slider_type_info, :sub_header2
    rename_column :slides, :general_slider_type_info, :sub_header
  end
end