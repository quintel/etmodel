class AddHouseSelectionToSlide < ActiveRecord::Migration
  def self.up
    add_column :slides, :house_selection, :boolean
  end

  def self.down
    remove_column :slides, :house_selection
  end
end