class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups, :force => true do |t|
      t.string :title
      t.timestamps
    end

    Group.create :title => "Primary energy demand"
    Group.create :title => "Final demand CBS"
    Group.create :title => "Useful demand"
    Group.create :title => "Sustainable electricity production"
    Group.create :title => "Energy import/export"
    Group.create :title => "Mining and extraction"
  end

  def self.down
    drop_table :groups
  end
end
