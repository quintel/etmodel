class CreateBlackboxScenarios < ActiveRecord::Migration
  def self.up
    create_table :blackbox_scenarios, :force => true do |t|
      t.string :name
      t.text :description

      t.text :user_values
      t.text :user_updates

      t.timestamps
    end

    BlackboxScenario.create(:name => "Empty", :description => "No Sliders used", :user_updates => {}.to_yaml, :user_values => {}.to_yaml)
  end

  def self.down
    drop_table :blackbox_scenarios
  end
end
