class DropComments < ActiveRecord::Migration

  def up
    drop_table :comments
  end

  def down
    raise ActiverRecord::IrreversibleMigration
  end

end
