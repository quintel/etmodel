class AddShortcutNamesToGroups < ActiveRecord::Migration
  def self.up
    Group.find(1 ).update_attribute :shortcut, "PD" # Primary energy demand
    Group.find(2 ).update_attribute :shortcut, "FD" # Final demand CBS
    Group.find(3 ).update_attribute :shortcut, "UD" # Useful demand
    Group.find(4 ).update_attribute :shortcut, "SP" # Sustainable production
    Group.find(5 ).update_attribute :shortcut, "IO" # Energy import/export
    Group.find(6 ).update_attribute :shortcut, "EG" # Extraction & growth
    Group.find(7 ).update_attribute :shortcut, "EP" # Electricity production
    Group.find(8 ).update_attribute :shortcut, "HP" # Heat production
    Group.find(9 ).update_attribute :shortcut, "DP" # Decentral Production
    Group.find(10).update_attribute :shortcut, "CP" #  Central Production
    Group.find(11).update_attribute :shortcut, "NU" #  Non energetic use
    Group.find(12).update_attribute :shortcut, "TC" #  Time curves
    Group.find(13).update_attribute :shortcut, "FC" #  footprint calculation
    Group.find(14).update_attribute :shortcut, "TF" rescue nil#  Transport fuels    
    Group.find(15).update_attribute :shortcut, "FE" rescue nil#  Final demand electricity
    Group.find(16).update_attribute :shortcut, "FE" rescue nil#  Final demand electricity
    Group.find(17).update_attribute :shortcut, "EX" rescue nil#  Energy export
  end

  def self.down
  end
end

