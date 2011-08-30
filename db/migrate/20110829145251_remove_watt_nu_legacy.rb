class RemoveWattNuLegacy < ActiveRecord::Migration
  def self.up
    remove_column :users, :trackable
    remove_column :users, :send_score
    remove_column :users, :new_round
    
    drop_table :rounds
  end

  def self.down
    add_column :users, :new_round, :boolean
    add_column :users, :send_score, :boolean,         :default => false
    add_column :users, :trackable, :string,          :default => "0"
  end
end
