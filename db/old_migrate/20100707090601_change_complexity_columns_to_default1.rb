class ChangeComplexityColumnsToDefault1 < ActiveRecord::Migration
  def self.up
    change_column :slides, :complexity ,:integer, :default => 1
    change_column :input_elements, :complexity ,:integer, :default => 1
    #just because its now default 1, doesnt mean its 1 in all the 'old' rows, DS 7 july 2010
    execute "UPDATE slides SET complexity = 1"
    execute "UPDATE input_elements SET complexity = 1"
  end

  def self.down
    change_column :slides, :complexity ,:integer
    change_column :input_elements, :complexity ,:integer
  end
end
