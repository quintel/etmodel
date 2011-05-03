class AddPeakDemands < ActiveRecord::Migration
  def self.up
    add_column :converters, :simult_wd, :float
    add_column :converters, :simult_sd, :float
    add_column :converters, :simult_wn, :float
    add_column :converters, :simult_sn, :float
  end

  def self.down
    remove_column :converters, :simult_sn
    remove_column :converters, :simult_wn
    remove_column :converters, :simult_sd
    remove_column :converters, :simult_wd
  end
end
