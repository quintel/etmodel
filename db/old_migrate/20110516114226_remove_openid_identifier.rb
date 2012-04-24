class RemoveOpenidIdentifier < ActiveRecord::Migration
  def self.up
    remove_column :users, :openid_identifier
  end

  def self.down
    add_column :users, :openid_identifier, :string
    add_index :users, :openid_identifier
  end
end
