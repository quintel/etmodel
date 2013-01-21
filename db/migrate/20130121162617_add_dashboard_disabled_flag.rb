class AddDashboardDisabledFlag < ActiveRecord::Migration
  def up
    add_column :constraints, :disabled, :boolean, :default => false
    add_index :constraints, :disabled
  end

  def down
    remove_column :constraints, :disabled
  end
end
