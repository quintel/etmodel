class CreateScenarios < ActiveRecord::Migration
  def self.up
    create_table :scenarios, :force => true do |t|
      t.string :author
      t.string :title
      t.text :description
      t.text :user_updates
      t.timestamps
    end
  end

  def self.down
    drop_table :scenarios
  end
end
