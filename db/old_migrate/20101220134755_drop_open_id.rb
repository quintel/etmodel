class DropOpenId < ActiveRecord::Migration
  def self.up
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
  end

  def self.down
  end
end
