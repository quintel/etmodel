class CreatePageTitles < ActiveRecord::Migration
  def self.up
    create_table :page_titles do |t|
      t.string :controller
      t.string :action
      t.text :content
      t.string :content_short
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :page_titles
  end
end
