class AddShortcutToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :shortcut, :string
  end

  def self.down
    remove_column :groups, :shortcut
  end
end
