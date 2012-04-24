class CreateGqueryGroups < ActiveRecord::Migration
  def self.up
    create_table :gquery_groups do |t|
      t.string :group_key

      t.timestamps
    end
  end

  def self.down
    drop_table :gquery_groups
  end
end
