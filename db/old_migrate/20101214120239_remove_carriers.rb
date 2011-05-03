class RemoveCarriers < ActiveRecord::Migration
  def self.up
    drop_table :carriers
  end

  def self.down
    ActiveRecord::IrreversibleMigration
  end
end
