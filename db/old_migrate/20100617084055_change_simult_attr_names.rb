class ChangeSimultAttrNames < ActiveRecord::Migration
  def self.up
    rename_column :converters, :simult_wn, :simult_we
    rename_column :converters, :simult_sn, :simult_se
  end

  def self.down
    rename_column :converters, :simult_se, :simult_sn
    rename_column :converters, :simult_we, :simult_wn
  end
end
