class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.string :key
      t.text :content_en
      t.text :content_nl

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
