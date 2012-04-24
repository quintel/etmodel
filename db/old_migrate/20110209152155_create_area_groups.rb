class CreateAreaGroups < ActiveRecord::Migration
  def self.up
    create_table :areagroups do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    
    create_table :areagroups_areas, :id => false do |t|
      t.integer :areagroup_id
      t.integer :area_id
    end
  end

  def self.down
    drop_table :areagroups
    drop_table :areagroups_areas
  end
end
