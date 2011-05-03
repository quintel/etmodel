class AddNewGroups < ActiveRecord::Migration
  def self.up
    Group.create :title => "Time curves"
    Group.create :title => "Biofuel distribution"
  end

  def self.down
  end
end
