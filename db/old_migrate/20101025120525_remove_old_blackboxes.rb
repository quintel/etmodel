class RemoveOldBlackboxes < ActiveRecord::Migration
  def self.up
    Blackbox.destroy_all
    BlackboxScenario.find(:all, :conditions => "id > 1").each(&:destroy)
  end

  def self.down
  end
end
