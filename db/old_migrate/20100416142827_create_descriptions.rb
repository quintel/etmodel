class CreateDescriptions < ActiveRecord::Migration
  def self.up
    create_table :descriptions do |t|
      t.text :content
      t.text :short_content
      t.references :describible, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :descriptions
  end
end
