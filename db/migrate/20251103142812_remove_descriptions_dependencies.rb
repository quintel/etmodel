class RemoveDescriptionsDependencies < ActiveRecord::Migration[7.1]
  def up
    drop_table :area_dependencies
    drop_table :descriptions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
