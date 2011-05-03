class ChangeLogosToPartners < ActiveRecord::Migration
  def self.up
    rename_table :logos, :partners
  end

  def self.down
    rename_table :partners, :logos
  end
end
