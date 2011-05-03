class AddEntityToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :entity, :string
  end

  def self.down
    remove_column :areas, :entity
  end
end
