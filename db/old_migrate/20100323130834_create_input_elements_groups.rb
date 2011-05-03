class CreateInputElementsGroups < ActiveRecord::Migration
  def self.up
    create_table :input_element_groups, :force => true do |t|
      t.string :name
    end

    14.times do |i|
      InputElementGroup.create :name => "untitled #{i}"
    end
  end

  def self.down
    drop_table :input_element_groups
  end
end
