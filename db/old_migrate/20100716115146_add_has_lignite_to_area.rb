class AddHasLigniteToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :has_lignite, :boolean
  end

  def self.down
    remove :areas, :has_lignite
  end
end
