class NewGroups < ActiveRecord::Migration
  def self.up
    Group.create(:title => "Electricity production")#, :key => "electricity_production")
    Group.create(:title => "Heat production") #, :key => "heat_production")
    Group.create(:title => "Decentral production") #, :key => "decentral_production")
  end

  def self.down
  end
end
