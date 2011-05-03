class AddSendScoreToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :send_score, :boolean, :default => false
  end

  def self.down
    remove_column :users, :send_score
  end
end
