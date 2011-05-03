class InternationalizeDescriptions < ActiveRecord::Migration
  def self.up
    rename_column :descriptions, :content, :content_en
    rename_column :descriptions, :short_content, :short_content_en
  end

  def self.down
    rename_column :descriptions, :content_en, :content
    rename_column :descriptions, :short_content_en, :short_content
  end
end
