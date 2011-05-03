class AddUseIdSectorIdAndKeyToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :use_id, :integer
    add_column :converters, :sector_id, :integer
    add_column :converters, :key, :string
  end

  def self.down
    remove_column :converters, :key
    remove_column :converters, :sector_id
    remove_column :converters, :use_id
  end
end
