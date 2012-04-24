class CreateGqueriesGqueryGroups < ActiveRecord::Migration
  def self.up
    create_table :gqueries_gquery_groups, :id => false do |t|
      t.string :gquery_id
      t.string :gquery_group_id
    end
  end

  def self.down
  end
end
