class AddComplexityToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :complexity, :integer, :default => 3
  end

  def self.down
    remove :scenarios, :complexity
  end
end
