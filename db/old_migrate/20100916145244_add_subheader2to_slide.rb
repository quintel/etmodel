class AddSubheader2toSlide < ActiveRecord::Migration
  def self.up
    add_column :slides, :sub_header2, :string
  end

  def self.down
    remove_column :slides, :sub_header2
  end
end
