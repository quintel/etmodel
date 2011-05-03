class AddInterfaceGroupToInputElement < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :interface_group, :string
  end

  def self.down
    remove_column :input_elements, :market_share_daylight_control
  end
end
