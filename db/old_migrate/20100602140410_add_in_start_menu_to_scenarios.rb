class AddInStartMenuToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :in_start_menu, :boolean
  end

  def self.down
    remove_column :scenarios, :in_start_menu
  end
end
