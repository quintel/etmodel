class AddSubHeaderToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :sub_header, :string
  end

  def self.down
    remove_column :slides, :sub_header
  end
end
