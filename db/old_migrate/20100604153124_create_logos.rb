class CreateLogos < ActiveRecord::Migration
  def self.up
    create_table :logos do |t|
      t.string :name
      t.string :url
      t.string :country
      t.integer :time
      t.boolean :repeat_any_other, :default => false
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :logos
  end
end
