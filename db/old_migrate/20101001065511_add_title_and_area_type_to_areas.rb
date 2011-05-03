class AddTitleAndAreaTypeToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :title, :string
  end

  def self.down
    remove_column :areas, :title
    
  end
end
