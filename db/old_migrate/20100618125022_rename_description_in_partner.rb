class RenameDescriptionInPartner < ActiveRecord::Migration
  def self.up
    rename_column :partners, :description, :subheader
  end

  def self.down
    rename_column :partners, :subheader, :description
  end
end
