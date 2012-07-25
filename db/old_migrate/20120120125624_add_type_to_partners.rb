class AddTypeToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :partner_type, :string, :default => 'general'
  end

  def self.down
    remove_column :partners, :partner_type
  end
end
