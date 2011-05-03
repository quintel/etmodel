class AddTranslationsToDescriptions < ActiveRecord::Migration
  def self.up
    add_column :descriptions, :content_nl, :text
    add_column :descriptions, :short_content_nl, :text
  end

  def self.down
    remove_column :descriptions, :short_content_nl
    remove_column :descriptions, :content_nl
  end
end
