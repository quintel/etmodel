class AddLongNameToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :long_name, :string
  end

  def self.down
    remove_column :partners, :long_name
  end

end
