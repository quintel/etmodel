class CreateBlueprintConvertersGroups < ActiveRecord::Migration
  def self.up
    create_table :blueprint_converters_groups, :force => true, :id => false do |t|
      t.integer :blueprint_converter_id
      t.integer :group_id
    end
  end

  def self.down
    drop_table :blueprint_converters_groups
  end
end
