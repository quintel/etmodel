class RemovePartnersTable < ActiveRecord::Migration
  def up
    drop_table :partners
    Description.where(describable_type: 'Partner').destroy_all
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
