class DropEsdlSuiteIds < ActiveRecord::Migration[7.1]
  def up
    drop_table :esdl_suite_ids
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
