class RenamePolicyLineToLine < ActiveRecord::Migration
  def self.up
    OutputElementType.find(9).update_attributes(:name => 'line')
  end

  def self.down
    OutputElementType.find(9).update_attributes(:name => 'policy_line')
  end
end
