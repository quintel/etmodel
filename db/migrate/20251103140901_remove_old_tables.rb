class RemoveOldTables < ActiveRecord::Migration[7.1]
  def up
    drop_table :texts
    drop_table :users_old
    drop_table :roles
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
