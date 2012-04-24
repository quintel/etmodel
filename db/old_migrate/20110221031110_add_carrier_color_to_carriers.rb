class AddCarrierColorToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :carrier_color, :string
  end

  def self.down
    remove_column :carriers, :carrier_color
  end
end
