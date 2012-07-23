class CleanupDb < ActiveRecord::Migration
  def up
    Description.where(:describable_type => 'Intro').delete_all
    Description.where(:describable_type => 'PageTitle').delete_all
    Description.where(:describable_type => '').delete_all
    Description.all.select{|d| d.describable.nil?}.each{|x| x.destroy}

    Version.where(:item_type => 'ExpertPrediction').delete_all
    Version.where(:item_type => 'Interface').delete_all
    Version.where(:item_type => 'PolicyGoal').delete_all
    Version.where(:item_type => 'Tab').delete_all
    Version.where(:item_type => 'Translation').delete_all
    Version.all.select{|x| x.item.nil?}.each{|x| x.destroy}
  end

  def down
  end
end
