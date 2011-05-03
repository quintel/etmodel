class RemoveSomeAttributes < ActiveRecord::Migration
  def self.up
    remove_column :converter_datas, :ccs_investment
    remove_column :converter_datas, :ccs_operation_and_maintenance
  end

  def self.down
    add_column :converter_datas, :ccs_operation_and_maintenance, :float
    add_column :converter_datas, :ccs_investment, :float
  end
end
