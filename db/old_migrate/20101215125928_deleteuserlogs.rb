class Deleteuserlogs < ActiveRecord::Migration
  def self.up
    drop_table :user_logs
  end

  def self.down
    ActiveRecord::IrreversibleMigration
  end
end
