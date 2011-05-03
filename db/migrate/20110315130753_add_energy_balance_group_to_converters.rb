class AddEnergyBalanceGroupToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :energy_balance_group, :string
  end

  def self.down
    remove_column :converters, :energy_balance_group
  end
end
