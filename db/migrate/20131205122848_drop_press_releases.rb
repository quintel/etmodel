class DropPressReleases < ActiveRecord::Migration
  def up
    drop_table :press_releases
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
