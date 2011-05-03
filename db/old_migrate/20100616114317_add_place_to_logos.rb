class AddPlaceToLogos < ActiveRecord::Migration
  def self.up
    add_column :logos, :place, :string, :default => "right"
  end

  def self.down
    remove_column :logos, :place
  end
end
