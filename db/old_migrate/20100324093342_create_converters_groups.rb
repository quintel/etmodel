class CreateConvertersGroups < ActiveRecord::Migration
  def self.up
    create_table :converters_groups, :force => true, :id => false do |t|
      t.integer :converter_id
      t.integer :group_id
    end
  end

  def self.down
    drop_table :converters_groups
  end
end
