class CreateBlueprints < ActiveRecord::Migration
  def self.up
    create_table :blueprints, :force => true do |t|
      t.string :name
      t.string :version
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :blueprints
  end
end
