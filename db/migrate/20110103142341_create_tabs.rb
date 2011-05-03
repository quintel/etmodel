class CreateTabs < ActiveRecord::Migration
  def self.up
    create_table :tabs, :force => true do |t|
      t.string :key
    end
    Tab.create :key => 'policy'
    Tab.create :key => 'demand'
    Tab.create :key => 'supply'
    Tab.create :key => 'costs'
  end

  def self.down
    drop_table :tabs
  end
end
